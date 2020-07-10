import 'package:accounting/models/user.dart';
import 'package:accounting/screens/wrapper.dart';
import 'package:accounting/services/authService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserId>.value(
      value: AuthService().userId,
      child:
          MaterialApp(theme: ThemeData(fontFamily: 'Raleway'), home: Wrapper()),
    );
  }
}
