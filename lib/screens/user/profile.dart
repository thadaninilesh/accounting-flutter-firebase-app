import 'package:accounting/commons/resources.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String error = '';
    bool isEditMode = true;
    return Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Card(
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Form(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 5),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          labelText:
                              isEditMode ? 'Name *' : 'Name (read only)'),
                      initialValue: 'Chander Thadani',
                      enabled: isEditMode,
                      onChanged: (val) {
                        setState(() {});
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          labelText: isEditMode
                              ? 'Business Name (optional)'
                              : 'Business Name (read only)'),
                      initialValue: 'Nilesh Furnitures',
                      enabled: isEditMode,
                      onChanged: (val) {
                        setState(() {});
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          labelText: isEditMode
                              ? 'Email address *'
                              : 'Email address (read only)'),
                      initialValue: 'thadanichander19@outlook.com',
                      enabled: isEditMode,
                      onChanged: (val) {
                        setState(() {});
                      },
                    ),
                    Divider(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          labelText: isEditMode
                              ? 'Website (optional)'
                              : 'Website (read only)'),
                      initialValue: 'www.nileshfurnitures.com',
                      enabled: isEditMode,
                      onChanged: (val) {
                        setState(() {});
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          labelText: isEditMode
                              ? 'Phone (optional)'
                              : 'Phone (read only)'),
                      initialValue: '9323111777',
                      enabled: isEditMode,
                      onChanged: (val) {
                        setState(() {});
                      },
                    ),
                    Divider(),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          labelText: isEditMode
                              ? 'GST (optional)'
                              : 'GST (read only)'),
                      initialValue: 'JIBDF2373I392U3',
                      enabled: isEditMode,
                      onChanged: (val) {
                        setState(() {});
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          labelText: isEditMode
                              ? 'PAN (optional)'
                              : 'PAN (read only)'),
                      initialValue: 'thadanichander19@outlook.com',
                      enabled: isEditMode,
                      onChanged: (val) {
                        setState(() {});
                      },
                    ),
                    Divider(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          labelText: isEditMode
                              ? ' (optional)'
                              : 'Address (read only)'),
                      initialValue: 'thadanichander19@outlook.com',
                      keyboardType: TextInputType.multiline,
                      minLines: 2,
                      maxLines: 5,
                      enabled: isEditMode,
                      onChanged: (val) {
                        setState(() {});
                      },
                    ),
                    RaisedButton(
                      color: Colors.red,
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                    ),
                  ],
                )),
              )),
        ));
  }
}
