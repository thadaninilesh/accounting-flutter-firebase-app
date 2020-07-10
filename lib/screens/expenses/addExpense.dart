import 'dart:collection';
import 'package:intl/intl.dart';

import 'package:accounting/commons/resources.dart';
import 'package:accounting/models/user.dart';
import 'package:accounting/screens/auth/signIn.dart';
import 'package:accounting/services/expenseService.dart';
import 'package:accounting/services/vendorService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExpense extends StatefulWidget {
  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final _formKey = GlobalKey<FormState>();
  HashMap expenseDetails = new HashMap<String, String>();
  String error = '';
  ExpenseService _expenseService = ExpenseService();

  DateTime selectedDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      expenseDetails.containsKey('date')
          ? expenseDetails.update('date', (value) => picked)
          : expenseDetails.putIfAbsent('date', () => picked);
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserId>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Add Expense', style: TextStyle(color: appBarTextColor)),
          elevation: appBarElevation,
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Vendor',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: VendorService().getVendorStream(userId),
                        builder: (context, snapshot) {
                          List<DropdownMenuItem> vendorDropdown = [];
                          if (!snapshot.hasData) {
                            return Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else {
                            for (int i = 0;
                                i < snapshot.data.documents.length;
                                i++) {
                              DocumentSnapshot vendorSnapshot =
                                  snapshot.data.documents[i];
                              vendorDropdown.add(DropdownMenuItem(
                                child: Text(vendorSnapshot.data['name']),
                                value: vendorSnapshot.documentID,
                              ));
                            }
                            return DropdownButtonFormField(
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Select Vendor'),
                              itemHeight: 60.0,
                              isExpanded: true,
                              items: vendorDropdown,
                              validator: (val) =>
                                  val == null || val.trim().isEmpty
                                      ? 'Vendor is required'
                                      : null,
                              onChanged: (val) {
                                setState(() {
                                  if (expenseDetails.containsKey('vendorUID')) {
                                    expenseDetails.update(
                                        'vendorUID', (value) => val.toString());
                                  } else {
                                    expenseDetails.putIfAbsent(
                                        'vendorUID', () => val.toString());
                                  }
                                });
                              },
                            );
                          }
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    DateTimeField(
                      format: DateFormat("dd-MMM-yyyy"),
                      decoration: textInputDecoration.copyWith(
                          labelText: 'Transaction Date'),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                      onChanged: (val) {
                        setState(() {
                          expenseDetails.containsKey('transactionDate')
                              ? expenseDetails.update(
                                  'transactionDate', (value) => val.toString())
                              : expenseDetails.putIfAbsent(
                                  'transactionDate', () => val.toString());
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          labelText: 'Amount (required)'),
                      onChanged: (val) {
                        setState(() {
                          expenseDetails.containsKey('amount')
                              ? expenseDetails.update(
                                  'amount', (value) => val.trim().toString())
                              : expenseDetails.putIfAbsent(
                                  'amount', () => val.trim().toString());
                        });
                      },
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          val.trim().isEmpty ? 'Amount is required' : null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          labelText: 'Expense notes (optional)'),
                      minLines: 2,
                      maxLines: 5,
                      maxLength: 200,
                      onChanged: (val) {
                        setState(() {
                          expenseDetails.containsKey('notes')
                              ? expenseDetails.update(
                                  'notes', (value) => val.trim().toString())
                              : expenseDetails.putIfAbsent(
                                  'notes', () => val.trim().toString());
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.topCenter,
                      child: RaisedButton(
                          color: primaryButtonBackgroundColor,
                          elevation: 5.0,
                          child: Text(
                            'Add Expense',
                            style: TextStyle(
                                color: primaryButtonTextColor, fontSize: 18),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              showProgressDialog(context, 'Adding Expense ...');
                              dynamic result = await _expenseService
                                  .addExpense(expenseDetails);
                              Navigator.pop(context);
                              if (result is String) {
                                setState(() {
                                  error = result.toString();
                                });
                              } else if (result is bool) {
                                if (result) {
                                  showSimpleDialogBox(context,
                                      'Expense Added Successfully', true);
                                } else {
                                  Navigator.popUntil(context,
                                      (Route<dynamic> route) => route.isFirst);
                                  return SignIn();
                                }
                              }
                            }
                          }),
                    )
                  ],
                )),
          ),
        ));
  }
}
