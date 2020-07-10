import 'package:accounting/commons/resources.dart';
import 'package:accounting/models/expenseManagement.dart';
import 'package:accounting/services/expenseService.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class ExpenseTile extends StatefulWidget {
  final Map<String, dynamic> expense;
  final int index;
  final String vendorName;

  ExpenseTile({this.expense, this.vendorName, this.index});
  @override
  _ExpenseTileState createState() => _ExpenseTileState();
}

class _ExpenseTileState extends State<ExpenseTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Card(
        elevation: 2.0,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: secondaryColor),
                            children: <TextSpan>[
                              TextSpan(text: "${widget.vendorName} - "),
                              TextSpan(
                                  text: "₹ ${widget.expense['amount']}",
                                  style: TextStyle(
                                      color: darkPrimaryColor,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 20))
                            ]),
                      ),
                      Divider(
                        height: 10,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Transaction Date: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: "${widget.expense['transactionDate']}"
                                      .substring(0, 10))
                            ]),
                      ),
                      SizedBox(
                        height: widget.expense.containsKey('notes') &&
                                widget.expense['notes'].toString().isNotEmpty
                            ? 5.0
                            : 0,
                      ),
                      widget.expense.containsKey('notes') &&
                              widget.expense['notes'].toString().isNotEmpty
                          ? RichText(
                              text: TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Notes: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(text: "${widget.expense['notes']}")
                                  ]),
                            )
                          : Container(),
                    ],
                  )),
            ),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      RaisedButton(
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.red,
                        onPressed: () async {
                          bool isSuccess = await ExpenseService()
                              .deleteExpense(widget.expense['expenseUID']);
                          showSimpleDialogBox(
                              context, 'Expense Deleted', false);
                        },
                      ),
                      RaisedButton(
                        child: Text(
                          'Edit',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: primaryLightColor,
                        onPressed: () {
                          showSimpleDialogBox(
                              context, 'This is under development', false);
                        },
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
