import 'dart:collection';

import 'package:accounting/commons/resources.dart';
import 'package:accounting/screens/auth/signIn.dart';
import 'package:accounting/services/clientService.dart';
import 'package:flutter/material.dart';

class EditClient extends StatefulWidget {
  final Map<String, dynamic> clientDetails;
  EditClient({this.clientDetails});

  @override
  _EditClientState createState() => _EditClientState();
}

class _EditClientState extends State<EditClient> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  ClientService _clientService = ClientService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Update Client', style: TextStyle(color: appBarTextColor)),
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
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Name (required)'),
                        validator: (val) => val == null && val.trim().isEmpty
                            ? 'Client is required'
                            : null,
                        initialValue: widget.clientDetails['clientName'],
                        onChanged: (val) {
                          widget.clientDetails.containsKey('clientName')
                              ? widget.clientDetails
                                  .update('clientName', (value) => val.trim())
                              : widget.clientDetails
                                  .putIfAbsent('clientName', () => val.trim());
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Email Address (optional)'),
                        keyboardType: TextInputType.emailAddress,
                        initialValue: widget.clientDetails['email'],
                        onChanged: (val) {
                          widget.clientDetails.containsKey('email')
                              ? widget.clientDetails
                                  .update('email', (value) => val.trim())
                              : widget.clientDetails
                                  .putIfAbsent('email', () => val.trim());
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Phone number (optional)'),
                        keyboardType: TextInputType.number,
                        initialValue: widget.clientDetails['phone'],
                        onChanged: (val) {
                          widget.clientDetails.containsKey('phone')
                              ? widget.clientDetails
                                  .update('phone', (value) => val.trim())
                              : widget.clientDetails
                                  .putIfAbsent('phone', () => val.trim());
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Website (optional)'),
                        initialValue: widget.clientDetails['website'],
                        onChanged: (val) {
                          widget.clientDetails.containsKey('website')
                              ? widget.clientDetails
                                  .update('website', (value) => val.trim())
                              : widget.clientDetails
                                  .putIfAbsent('website', () => val.trim());
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Address (optional)'),
                        keyboardType: TextInputType.multiline,
                        minLines: 2,
                        maxLines: 5,
                        initialValue: widget.clientDetails['address'],
                        onChanged: (val) {
                          setState(() {
                            widget.clientDetails.containsKey('address')
                                ? widget.clientDetails.update(
                                    'address', (value) => val.trim().toString())
                                : widget.clientDetails.putIfAbsent(
                                    'address', () => val.trim().toString());
                          });
                        },
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.topCenter,
                        child: RaisedButton(
                            color: primaryButtonBackgroundColor,
                            elevation: 5.0,
                            child: Text(
                              'Update Client',
                              style: TextStyle(
                                  color: primaryButtonTextColor, fontSize: 18),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                showProgressDialog(
                                    context, 'Updating Client ...');
                                dynamic result = await _clientService
                                    .updateClient(widget.clientDetails);
                                Navigator.pop(context);
                                if (result is String) {
                                  setState(() {
                                    error = result.toString();
                                  });
                                } else if (result is bool) {
                                  if (result) {
                                    showSimpleDialogBox(context,
                                        'Client Added Successfully', true);
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
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        error,
                        style: TextStyle(color: errorColor),
                      ),
                    ],
                  )))),
    );
  }
}
