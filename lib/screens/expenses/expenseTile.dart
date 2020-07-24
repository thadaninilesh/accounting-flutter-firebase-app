import 'package:accounting/commons/resources.dart';
import 'package:accounting/screens/expenses/updateExpense.dart';
import 'package:accounting/services/expenseService.dart';
import 'package:flutter/material.dart';

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
          child: ExpansionTile(
        subtitle: Text(
          widget.expense['notes'],
          style: TextStyle(color: Colors.grey[600]),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                "${widget.expense['transactionDate']}".substring(0, 10),
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                "${widget.vendorName}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: secondaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
                flex: 1,
                child: Text(
                  "₹ ${widget.expense['amount']}",
                  textAlign: TextAlign.right,
                )),
          ],
        ),
        children: <Widget>[
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  showSimpleDialogBox(context, 'Expense Deleted', false);
                  setState(() {});
                },
              ),
              RaisedButton(
                child: Text(
                  'Edit',
                  style: TextStyle(color: Colors.white),
                ),
                color: primaryLightColor,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditExpense(
                              expenseDetails: widget.expense,
                              vendorName: widget.vendorName)));
                },
              )
            ],
          )
        ],
      )),
    );
  }
}
