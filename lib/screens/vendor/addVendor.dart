import 'dart:collection';

import 'package:accounting/commons/resources.dart';
import 'package:accounting/screens/auth/signIn.dart';
import 'package:accounting/services/vendorService.dart';
import 'package:flutter/material.dart';

class AddVendor extends StatefulWidget {
  @override
  _AddVendorState createState() => _AddVendorState();
}

class _AddVendorState extends State<AddVendor> {
  final _formKey = GlobalKey<FormState>();
  HashMap vendorDetails = new HashMap<String, String>();
  String error = '';
  VendorService _vendorService = VendorService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Add Vendor', style: TextStyle(color: appBarTextColor)),
          elevation: appBarElevation,
        ),
        body: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: 'Vendor Name (required)'),
                    onChanged: (val) {
                      setState(() {
                        vendorDetails.containsKey('name')
                            ? vendorDetails.update(
                                'name', (value) => val.trim().toString())
                            : vendorDetails.putIfAbsent(
                                'name', () => val.trim().toString());
                      });
                    },
                    validator: (val) =>
                        val.trim().isEmpty ? 'Vendor name is required' : null,
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: 'Email Address (optional)'),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (val) {
                      setState(() {
                        vendorDetails.containsKey('email')
                            ? vendorDetails.update(
                                'email', (value) => val.trim().toString())
                            : vendorDetails.putIfAbsent(
                                'email', () => val.trim().toString());
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: 'Phone (optional)'),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() {
                        vendorDetails.containsKey('phone')
                            ? vendorDetails.update(
                                'phone', (value) => val.trim().toString())
                            : vendorDetails.putIfAbsent(
                                'phone', () => val.trim().toString());
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: 'Website (optional)'),
                    onChanged: (val) {
                      setState(() {
                        vendorDetails.containsKey('website')
                            ? vendorDetails.update(
                                'website', (value) => val.trim().toString())
                            : vendorDetails.putIfAbsent(
                                'website', () => val.trim().toString());
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: 'GST (optional)'),
                    onChanged: (val) {
                      setState(() {
                        vendorDetails.containsKey('gst')
                            ? vendorDetails.update(
                                'gst', (value) => val.trim().toString())
                            : vendorDetails.putIfAbsent(
                                'gst', () => val.trim().toString());
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: 'PAN (optional)'),
                    onChanged: (val) {
                      setState(() {
                        vendorDetails.containsKey('pan')
                            ? vendorDetails.update(
                                'pan', (value) => val.trim().toString())
                            : vendorDetails.putIfAbsent(
                                'pan', () => val.trim().toString());
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: 'Address (optional)'),
                    keyboardType: TextInputType.multiline,
                    minLines: 2,
                    maxLines: 5,
                    onChanged: (val) {
                      setState(() {
                        vendorDetails.containsKey('address')
                            ? vendorDetails.update(
                                'address', (value) => val.trim().toString())
                            : vendorDetails.putIfAbsent(
                                'address', () => val.trim().toString());
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2,
                    child: RaisedButton(
                      color: primaryButtonBackgroundColor,
                      elevation: 5.0,
                      child: Text(
                        'Add Vendor',
                        style: TextStyle(
                            color: primaryButtonTextColor, fontSize: 18),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          showProgressDialog(context, 'Adding Vendor...');
                          dynamic result =
                              await _vendorService.addVendor(vendorDetails);
                          Navigator.pop(context);
                          if (result is String) {
                            setState(() {
                              error = result.toString();
                            });
                          } else if (result is bool) {
                            if (result) {
                              showSimpleDialogBox(
                                  context, 'Vendor Added Successfully', true);
                            } else {
                              Navigator.popUntil(context,
                                  (Route<dynamic> route) => route.isFirst);
                              return SignIn();
                            }
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    error,
                    style: TextStyle(color: errorColor),
                  ),
                ],
              ),
            ))));
  }
}
