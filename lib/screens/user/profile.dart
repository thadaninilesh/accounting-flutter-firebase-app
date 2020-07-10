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
    return Container(
      child: RaisedButton(
        child: Text('Logout'),
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
      ),
    );
  }
}
