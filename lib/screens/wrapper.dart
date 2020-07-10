import 'package:accounting/models/user.dart';
import 'package:accounting/screens/auth/signIn.dart';
import 'package:accounting/screens/home/home.dart';
import 'package:accounting/services/authService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Stream userStream;
  User userData;
  bool loading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserId>(context);

    return userId == null
        ? SignIn()
        : FutureBuilder(
            future: AuthService().getUserFromFirestore(userId.uid),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData) {
                userData = snapshot.data;
                return Home();
              } else {
                return SignIn();
              }
            },
          );
  }
}
