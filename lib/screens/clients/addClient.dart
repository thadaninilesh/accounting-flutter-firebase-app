import 'dart:collection';

import 'package:accounting/commons/resources.dart';
import 'package:accounting/screens/auth/signIn.dart';
import 'package:accounting/services/clientService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddClient extends StatefulWidget {
  @override
  _AddClientState createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  final _formKey = GlobalKey<FormState>();
  HashMap clientDetails = new HashMap<String, String>();
  String error = '';
  ClientService _clientService = ClientService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Add Client', style: TextStyle(color: appBarTextColor)),
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
                        onChanged: (val) {
                          clientDetails.containsKey('clientName')
                              ? clientDetails.update(
                                  'clientName', (value) => val.trim())
                              : clientDetails.putIfAbsent(
                                  'clientName', () => val.trim());
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Email Address (optional)'),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (val) {
                          clientDetails.containsKey('email')
                              ? clientDetails.update(
                                  'email', (value) => val.trim())
                              : clientDetails.putIfAbsent(
                                  'email', () => val.trim());
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Phone number (optional)'),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          clientDetails.containsKey('phone')
                              ? clientDetails.update(
                                  'phone', (value) => val.trim())
                              : clientDetails.putIfAbsent(
                                  'phone', () => val.trim());
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Website (optional)'),
                        onChanged: (val) {
                          clientDetails.containsKey('website')
                              ? clientDetails.update(
                                  'website', (value) => val.trim())
                              : clientDetails.putIfAbsent(
                                  'website', () => val.trim());
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
                        onChanged: (val) {
                          setState(() {
                            clientDetails.containsKey('address')
                                ? clientDetails.update(
                                    'address', (value) => val.trim().toString())
                                : clientDetails.putIfAbsent(
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
                              'Add Client',
                              style: TextStyle(
                                  color: primaryButtonTextColor, fontSize: 18),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                showProgressDialog(
                                    context, 'Adding Client ...');
                                dynamic result = await _clientService
                                    .addClient(clientDetails);
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
