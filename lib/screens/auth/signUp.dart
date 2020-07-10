import 'package:accounting/commons/loader.dart';
import 'package:accounting/commons/resources.dart';
import 'package:accounting/models/user.dart';
import 'package:accounting/services/authService.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  String fullName;
  String emailAddress;
  String password;
  String phoneNumber;
  String businessName;
  bool loading = false;
  String error = '';
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loader()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              title: Text('Sign Up', style: TextStyle(color: appBarTextColor)),
              elevation: appBarElevation,
            ),
            body: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    alignment: Alignment.center,
                    child: Form(
                        key: _formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              FlutterLogo(
                                size: 60,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: 'Full Name *'),
                                validator: (val) => val.isEmpty
                                    ? 'Full name is required'
                                    : null,
                                keyboardType: TextInputType.text,
                                onChanged: (val) {
                                  setState(
                                      () => fullName = val.trim().toString());
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: 'Business Name (optional)'),
                                keyboardType: TextInputType.text,
                                onChanged: (val) {
                                  setState(() =>
                                      businessName = val.trim().toString());
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: 'Phone Number (optional)'),
                                keyboardType: TextInputType.number,
                                onChanged: (val) {
                                  setState(() =>
                                      phoneNumber = val.trim().toString());
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: 'Email Address *'),
                                validator: (val) =>
                                    val.isEmpty ? 'Email is required' : null,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (val) {
                                  setState(() =>
                                      emailAddress = val.trim().toString());
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: 'Password *'),
                                validator: (val) =>
                                    val.isEmpty ? 'Password is required' : null,
                                obscureText: true,
                                onChanged: (val) {
                                  setState(
                                      () => password = val.trim().toString());
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                height: 50,
                                child: RaisedButton(
                                  color: primaryButtonBackgroundColor,
                                  elevation: 5.0,
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        color: primaryButtonTextColor,
                                        fontSize: 18),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() => loading = true);
                                      dynamic result = await _auth.signUp(
                                          fullName: fullName,
                                          emailAddress: emailAddress,
                                          password: password,
                                          phoneNumber: phoneNumber,
                                          businessName: businessName);
                                      if (!(result is bool)) {
                                        setState(() {
                                          error = result.toString();
                                          loading = false;
                                        });
                                      } else {
                                        setState(() => loading = false);
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                child: RichText(
                                  text: TextSpan(
                                      text: 'Have an account already? ',
                                      style: TextStyle(
                                          color: primaryColor, fontSize: 16),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Sign In here!',
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ]),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                error,
                                style: TextStyle(color: errorColor),
                              ),
                            ])))));
  }
}
