import 'dart:collection';

import 'package:accounting/commons/resources.dart';
import 'package:accounting/models/user.dart';
import 'package:accounting/services/authService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorService {
  final Firestore _firestore = Firestore.instance;
  final AuthService _authService = AuthService();

  Future<dynamic> addVendor(HashMap<String, String> vendorDetails) async {
    dynamic result = await _authService.getCurrentUserId();
    String response = '';
    if (result is UserId) {
      vendorDetails.putIfAbsent('userUID', () => result.uid);
      HashMap<String, dynamic> vendorMap = vendorDetails;
      vendorMap.putIfAbsent('createdAt', () => FieldValue.serverTimestamp());
      vendorMap.putIfAbsent('updatedAt', () => FieldValue.serverTimestamp());
      await _firestore
          .collection(VENDORS_COLLECTION)
          .add(vendorMap)
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

  Future<List<dynamic>> getVendors() async {
    dynamic user = await _authService.getCurrentUserId();
    List<Map<String, dynamic>> vendors = List();
    if (user is UserId) {
      QuerySnapshot vendorsSnapshot = await _firestore
          .collection(VENDORS_COLLECTION)
          .where('userUID', isEqualTo: user.uid)
          .orderBy('updatedAt', descending: true)
          .getDocuments();
      vendorsSnapshot.documents.forEach((element) {
        Map<String, dynamic> vendor = element.data;
        vendor.putIfAbsent('vendorUID', () => element.documentID);
        vendors.add(vendor);
      });
    } else {
      return null;
    }
    return vendors;
  }

  Stream<QuerySnapshot> getVendorStream(UserId user) {
    return _firestore
        .collection(VENDORS_COLLECTION)
        .where('userUID', isEqualTo: user.uid)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  Future updateVendor(Map<String, dynamic> vendorDetails) async {
    dynamic result = await _authService.getCurrentUserId();
    String response = '';
    if (result is UserId) {
      vendorDetails.putIfAbsent('userUID', () => result.uid);
      Map<String, dynamic> vendorMap = vendorDetails;
      vendorMap.update('updatedAt', (val) => FieldValue.serverTimestamp());
      String vendorUID = vendorMap['vendorUID'];
      vendorMap.remove('vendorUID');
      await _firestore
          .collection(VENDORS_COLLECTION)
          .document(vendorUID)
          .setData(vendorMap)
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

  Future<Map<String, dynamic>> getVendorById(String vendorId) async {
    dynamic user = await _authService.getCurrentUserId();

    if (user is UserId) {
      DocumentSnapshot vendorDocument = await _firestore
          .collection(VENDORS_COLLECTION)
          .document(vendorId)
          .get();
      return vendorDocument.data;
    } else {
      return null;
    }
  }

  Future<HashMap<String, String>> getVendorNamesByUserId(String userUID) async {
    QuerySnapshot vendorSnapshots = await _firestore
        .collection(VENDORS_COLLECTION)
        .where('userUID', isEqualTo: userUID)
        .getDocuments();

    HashMap<String, String> vendorUIDvsVendorName = HashMap();
    vendorSnapshots.documents.forEach((element) {
      vendorUIDvsVendorName.putIfAbsent(
          element.documentID, () => element.data['name']);
    });
    return vendorUIDvsVendorName;
  }

  Future<bool> deleteVendor(String vendorUID) async {
    bool isSuccess = true;
    await _firestore
        .collection(VENDORS_COLLECTION)
        .document(vendorUID)
        .delete()
        .catchError((e) => isSuccess = false);
    return isSuccess;
  }
}
