import 'package:accounting/commons/resources.dart';
import 'package:accounting/models/user.dart';
import 'package:accounting/screens/user/editProfile.dart';
import 'package:accounting/services/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserId>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Profile', style: TextStyle(color: appBarTextColor)),
          elevation: appBarElevation,
        ),
        body: FutureBuilder(
          future: AuthService().getUserFromFirestore(userId.uid),
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            if (snapshot.hasData) {
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
                                    labelText: 'Name (read only)'),
                                initialValue: snapshot.data.userName ?? '',
                                enabled: false,
                                onChanged: (val) {
                                  setState(() {});
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: 'Business Name (read only)'),
                                initialValue: snapshot.data.businessName ?? '',
                                enabled: false,
                                onChanged: (val) {
                                  setState(() {});
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  decoration: textInputDecoration.copyWith(
                                      labelText: 'Email address (read only)'),
                                  initialValue:
                                      snapshot.data.emailAddress ?? '',
                                  enabled: false),
                              Divider(
                                height: 20,
                              ),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: 'Website (read only)'),
                                initialValue: snapshot.data.website ?? '',
                                enabled: false,
                                onChanged: (val) {
                                  setState(() {});
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: 'Phone (read only)'),
                                initialValue: snapshot.data.phoneNumber ?? '',
                                enabled: false,
                                onChanged: (val) {
                                  setState(() {});
                                },
                              ),
                              Divider(),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: 'GST (read only)'),
                                initialValue: snapshot.data.gst ?? '',
                                enabled: false,
                                onChanged: (val) {
                                  setState(() {});
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: 'PAN (read only)'),
                                initialValue: snapshot.data.pan ?? '',
                                enabled: false,
                                onChanged: (val) {
                                  setState(() {});
                                },
                              ),
                              Divider(
                                height: 20,
                              ),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: 'Address (read only)'),
                                initialValue: snapshot.data.address ?? '',
                                keyboardType: TextInputType.multiline,
                                minLines: 2,
                                maxLines: 5,
                                enabled: false,
                                onChanged: (val) {
                                  setState(() {});
                                },
                              ),
                              RaisedButton(
                                color: secondaryColor,
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditProfile(
                                              user: snapshot.data)));
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
            } else if (snapshot.connectionState == ConnectionState.active) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ));
  }
}
