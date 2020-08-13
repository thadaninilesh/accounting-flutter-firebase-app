import 'package:accounting/commons/resources.dart';
import 'package:accounting/models/user.dart';
import 'package:accounting/services/authService.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final User user;
  EditProfile({this.user});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  String error = '';

  @override
  Widget build(BuildContext context) {
    String fullName = widget.user.userName,
        businessName = widget.user.businessName,
        address = widget.user.address,
        emailAddress = widget.user.emailAddress,
        phoneNumber = widget.user.phoneNumber,
        website = widget.user.website,
        gst = widget.user.gst,
        pan = widget.user.pan;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Edit Profile', style: TextStyle(color: appBarTextColor)),
          elevation: appBarElevation,
        ),
        body: Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(height: 5),
                            TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: 'Email address (read only)'),
                                initialValue: emailAddress ?? '',
                                enabled: false),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Name'),
                              initialValue: fullName ?? '',
                              onChanged: (val) {
                                fullName = val.trim();
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Business Name (optional)'),
                              initialValue: businessName ?? '',
                              onChanged: (val) {
                                businessName = val.trim();
                              },
                            ),
                            Divider(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Website (optional)'),
                              initialValue: website ?? '',
                              onChanged: (val) {
                                website = val.trim();
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Phone (optional)'),
                              initialValue: phoneNumber ?? '',
                              onChanged: (val) {
                                phoneNumber = val.trim();
                              },
                            ),
                            Divider(),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'GST (optional)'),
                              initialValue: widget.user.gst ?? '',
                              onChanged: (val) {
                                gst = val.trim();
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'PAN (optional)'),
                              initialValue: widget.user.pan ?? '',
                              onChanged: (val) {
                                pan = val.trim();
                              },
                            ),
                            Divider(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Address (optional)'),
                              initialValue: widget.user.address ?? '',
                              keyboardType: TextInputType.multiline,
                              minLines: 2,
                              maxLines: 5,
                              onChanged: (val) {
                                address = val.trim();
                              },
                            ),
                            RaisedButton(
                              color: secondaryColor,
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                showProgressDialog(
                                    context, 'Updating Your Profile ...');
                                dynamic result = await AuthService().updateUser(
                                    User(
                                        uid: widget.user.uid,
                                        userName: fullName,
                                        businessName: businessName,
                                        emailAddress: emailAddress,
                                        address: address,
                                        website: website,
                                        phoneNumber: phoneNumber,
                                        gst: gst,
                                        pan: pan));
                                Navigator.pop(context);
                                if (result is String) {
                                  setState(() {
                                    error = result.toString();
                                  });
                                } else {
                                  showSimpleDialogBox(context,
                                      'Profile Updated Successfully', true);
                                }
                              },
                            ),
                          ],
                        )),
                  )),
            )));
  }
}
