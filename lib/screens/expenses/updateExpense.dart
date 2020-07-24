import 'package:accounting/commons/resources.dart';
import 'package:accounting/models/user.dart';
import 'package:accounting/screens/auth/signIn.dart';
import 'package:accounting/services/expenseService.dart';
import 'package:accounting/services/vendorService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EditExpense extends StatefulWidget {
  final Map<String, dynamic> expenseDetails;
  final String vendorName;
  EditExpense({this.expenseDetails, this.vendorName});
  @override
  _EditExpenseState createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  ExpenseService _expenseService = ExpenseService();

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserId>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Edit Expense', style: TextStyle(color: appBarTextColor)),
        elevation: appBarElevation,
      ),
      body: Container(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 5),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Vendor (read only)',
                            fillColor: Colors.grey[200]),
                        initialValue: widget.vendorName,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold),
                        readOnly: true,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DateTimeField(
                        format: DateFormat("dd-MMM-yyyy"),
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Transaction Date'),
                        initialValue: DateTime.parse(
                            widget.expenseDetails['transactionDate']),
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                        },
                        onChanged: (val) {
                          setState(() {
                            widget.expenseDetails.containsKey('transactionDate')
                                ? widget.expenseDetails.update(
                                    'transactionDate',
                                    (value) => val.toString())
                                : widget.expenseDetails.putIfAbsent(
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
                        initialValue: widget.expenseDetails['amount'],
                        onChanged: (val) {
                          setState(() {
                            widget.expenseDetails.containsKey('amount')
                                ? widget.expenseDetails.update(
                                    'amount', (value) => val.trim().toString())
                                : widget.expenseDetails.putIfAbsent(
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
                        initialValue: widget.expenseDetails['notes'],
                        onChanged: (val) {
                          setState(() {
                            widget.expenseDetails.containsKey('notes')
                                ? widget.expenseDetails.update(
                                    'notes', (value) => val.trim().toString())
                                : widget.expenseDetails.putIfAbsent(
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
                              'Update Expense',
                              style: TextStyle(
                                  color: primaryButtonTextColor, fontSize: 18),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                showProgressDialog(
                                    context, 'Updating Expense ...');
                                dynamic result = await _expenseService
                                    .updateExpense(widget.expenseDetails);
                                Navigator.pop(context);
                                if (result is String) {
                                  setState(() {
                                    error = result.toString();
                                  });
                                } else if (result is bool) {
                                  if (result) {
                                    showSimpleDialogBox(context,
                                        'Expense Updated Successfully', true);
                                  } else {
                                    Navigator.popUntil(
                                        context,
                                        (Route<dynamic> route) =>
                                            route.isFirst);
                                    return SignIn();
                                  }
                                }
                              }
                            }),
                      )
                    ],
                  )))),
    );
  }
}
