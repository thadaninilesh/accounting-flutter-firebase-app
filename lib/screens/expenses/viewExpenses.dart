import 'dart:collection';

import 'package:accounting/commons/resources.dart';
import 'package:accounting/models/expenseManagement.dart';
import 'package:accounting/models/user.dart';
import 'package:accounting/screens/expenses/addExpense.dart';
import 'package:accounting/screens/expenses/expenseTile.dart';
import 'package:accounting/services/expenseService.dart';
import 'package:accounting/services/vendorService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageExpenses extends StatefulWidget {
  @override
  ManageExpensesState createState() => ManageExpensesState();
}

class ManageExpensesState extends State<ManageExpenses> {
  final _formKey = GlobalKey<FormState>();
  HashMap expenseDetails = new HashMap<String, String>();
  String error = '';
  ExpenseService _expenseService = ExpenseService();

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserId>(context);

    return Container(
        padding: EdgeInsets.all(5),
        child: Column(children: <Widget>[
          Center(
              child: RaisedButton(
            color: primaryLightColor,
            child: Text(
              'Add Expense',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddExpense()));
            },
          )),
          Divider(),
          Flexible(
              child: FutureBuilder(
                  future: VendorService().getVendorNamesByUserId(userId.uid),
                  builder: (BuildContext context,
                      AsyncSnapshot<HashMap<String, String>> vendorSnapshot) {
                    if (vendorSnapshot.connectionState !=
                        ConnectionState.done) {
                      return Container(
                          child: Center(
                        child: CircularProgressIndicator(),
                      ));
                    } else {
                      if (vendorSnapshot.hasData) {
                        return StreamBuilder<QuerySnapshot>(
                            stream: ExpenseService().getExpenseStream(userId),
                            builder: (context, expenseSnapshot) {
                              if (false) {
                                // check here, leads to infinite loading. @TODO
                                return Container(
                                    child: Center(
                                  child: CircularProgressIndicator(),
                                ));
                              } else {
                                if (!expenseSnapshot.hasData) {
                                  return Container(
                                      child: Center(
                                    child: Text(
                                        'You have not added any expense yet.'),
                                  ));
                                } else {
                                  return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount:
                                        expenseSnapshot.data.documents.length,
                                    itemBuilder: (context, index) {
                                      expenseSnapshot.data.documents[index].data
                                          .putIfAbsent(
                                              'expenseUID',
                                              () => expenseSnapshot.data
                                                  .documents[index].documentID);
                                      return ExpenseTile(
                                        expense: expenseSnapshot
                                            .data.documents[index].data,
                                        vendorName: vendorSnapshot.data[
                                            expenseSnapshot
                                                .data
                                                .documents[index]
                                                .data['vendorUID']],
                                      );
                                    },
                                  );
                                }
                              }
                            });
                      } else {
                        return Container(
                            child: Center(
                          child: Text('You first need to add a vendor.'),
                        ));
                      }
                    }
                  }))
        ]));
  }
}
