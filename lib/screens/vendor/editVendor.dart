import 'package:accounting/commons/resources.dart';
import 'package:accounting/screens/auth/signIn.dart';
import 'package:accounting/services/vendorService.dart';
import 'package:flutter/material.dart';

class EditVendor extends StatefulWidget {
  final Map<String, dynamic> vendorDetails;
  EditVendor({this.vendorDetails});

  @override
  _EditVendorState createState() => _EditVendorState();
}

class _EditVendorState extends State<EditVendor> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  VendorService _vendorService = VendorService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Edit Vendor', style: TextStyle(color: appBarTextColor)),
          elevation: appBarElevation,
        ),
        body: Container(
            // padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(20),
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
                    initialValue: widget.vendorDetails['name'],
                    onChanged: (val) {
                      setState(() {
                        widget.vendorDetails.containsKey('name')
                            ? widget.vendorDetails.update(
                                'name', (value) => val.trim().toString())
                            : widget.vendorDetails.putIfAbsent(
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
                    initialValue: widget.vendorDetails['email'],
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (val) {
                      setState(() {
                        widget.vendorDetails.containsKey('email')
                            ? widget.vendorDetails.update(
                                'email', (value) => val.trim().toString())
                            : widget.vendorDetails.putIfAbsent(
                                'email', () => val.trim().toString());
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: 'Phone (optional)'),
                    keyboardType: TextInputType.number,
                    initialValue: widget.vendorDetails['phone'],
                    onChanged: (val) {
                      setState(() {
                        widget.vendorDetails.containsKey('phone')
                            ? widget.vendorDetails.update(
                                'phone', (value) => val.trim().toString())
                            : widget.vendorDetails.putIfAbsent(
                                'phone', () => val.trim().toString());
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: 'Website (optional)'),
                    initialValue: widget.vendorDetails['website'],
                    onChanged: (val) {
                      setState(() {
                        widget.vendorDetails.containsKey('website')
                            ? widget.vendorDetails.update(
                                'website', (value) => val.trim().toString())
                            : widget.vendorDetails.putIfAbsent(
                                'website', () => val.trim().toString());
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: 'GST (optional)'),
                    initialValue: widget.vendorDetails['gst'],
                    onChanged: (val) {
                      setState(() {
                        widget.vendorDetails.containsKey('gst')
                            ? widget.vendorDetails
                                .update('gst', (value) => val.trim().toString())
                            : widget.vendorDetails.putIfAbsent(
                                'gst', () => val.trim().toString());
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: 'PAN (optional)'),
                    initialValue: widget.vendorDetails['pan'],
                    onChanged: (val) {
                      setState(() {
                        widget.vendorDetails.containsKey('pan')
                            ? widget.vendorDetails
                                .update('pan', (value) => val.trim().toString())
                            : widget.vendorDetails.putIfAbsent(
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
                    initialValue: widget.vendorDetails['address'],
                    onChanged: (val) {
                      setState(() {
                        widget.vendorDetails.containsKey('address')
                            ? widget.vendorDetails.update(
                                'address', (value) => val.trim().toString())
                            : widget.vendorDetails.putIfAbsent(
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
                        'Update Vendor',
                        style: TextStyle(
                            color: primaryButtonTextColor, fontSize: 18),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          showProgressDialog(context, 'Updating Vendor...');
                          dynamic result = await _vendorService
                              .updateVendor(widget.vendorDetails);
                          Navigator.pop(context);
                          if (result is String) {
                            setState(() {
                              error = result.toString();
                            });
                          } else if (result is bool) {
                            if (result) {
                              showSimpleDialogBox(
                                  context, 'Vendor Updated Successfully', true);
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
