import 'dart:collection';

import 'package:accounting/commons/resources.dart';
import 'package:accounting/models/expenseManagement.dart';
import 'package:accounting/models/user.dart';
import 'package:accounting/services/authService.dart';
import 'package:accounting/services/vendorService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseService {
  final Firestore _firestore = Firestore.instance;
  final AuthService _authService = AuthService();

  Future<dynamic> addExpense(HashMap<String, dynamic> expenseDetails) async {
    dynamic result = await _authService.getCurrentUserId();
    String response = '';
    if (result is UserId) {
      expenseDetails.putIfAbsent('userUID', () => result.uid);
      HashMap<String, dynamic> expenseMap = HashMap();
      expenseMap.addAll(expenseDetails);
      expenseMap.putIfAbsent('createdAt', () => FieldValue.serverTimestamp());
      expenseMap.putIfAbsent('updatedAt', () => FieldValue.serverTimestamp());
      await _firestore
          .collection(EXPENSES_COLLECTION)
          .add(expenseMap)
          .catchError((e) => {response = e.toString()});
      if (response.isNotEmpty) {
        return response;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Future<Expense> getExpenses() async {
    dynamic user = await _authService.getCurrentUserId();
    List<Map<String, dynamic>> expenses = List();
    HashMap<String, String> vendorUIDVsVendorName = HashMap();
    Set<String> vendorUIDs = Set();
    if (user is UserId) {
      QuerySnapshot expensesSnapshot = await _firestore
          .collection(EXPENSES_COLLECTION)
          .where('userUID', isEqualTo: user.uid)
          .orderBy('updatedAt', descending: true)
          .getDocuments();
      expensesSnapshot.documents.forEach((element) {
        Map<String, dynamic> expense = element.data;
        expense.putIfAbsent('expenseUID', () => element.documentID);
        expenses.add(expense);
        vendorUIDs.add(expense['vendorUID']);
      });
      if (expenses.length > 0) {
        vendorUIDVsVendorName =
            await VendorService().getVendorNamesByUserId(user.uid);
      }
    } else {
      return null;
    }
    return Expense(
        expenses: expenses, vendorUIDVsVendorName: vendorUIDVsVendorName);
  }

  Future updateExpense(Map<String, dynamic> expenseDetails) async {
    dynamic result = await _authService.getCurrentUserId();
    String response = '';
    if (result is UserId) {
      expenseDetails.putIfAbsent('userUID', () => result.uid);
      Map<String, dynamic> expenseMap = expenseDetails;
      expenseMap.update('updatedAt', (val) => FieldValue.serverTimestamp());
      String expenseUID = expenseMap['expenseUID'];
      expenseMap.remove('expenseUID');
      await _firestore
          .collection(EXPENSES_COLLECTION)
          .document(expenseUID)
          .setData(expenseMap)
          .catchError((e) => {response = e.toString()});
      if (response.isNotEmpty) {
        return response;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> getExpenseById(String expenseId) async {
    dynamic user = await _authService.getCurrentUserId();

    if (user is UserId) {
      DocumentSnapshot expenseDocument = await _firestore
          .collection(EXPENSES_COLLECTION)
          .document(expenseId)
          .get();
      return expenseDocument.data;
    } else {
      return null;
    }
  }

  Stream<QuerySnapshot> getExpenseStream(UserId user) {
    return _firestore
        .collection(EXPENSES_COLLECTION)
        .where('userUID', isEqualTo: user.uid)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  Future<bool> deleteExpense(String expenseUID) async {
    bool isSuccess = true;
    await _firestore
        .collection(EXPENSES_COLLECTION)
        .document(expenseUID)
        .delete()
        .catchError((e) => isSuccess = false);
    return isSuccess;
  }
}
