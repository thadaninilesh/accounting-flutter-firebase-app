import 'package:accounting/commons/loader.dart';
import 'package:accounting/commons/resources.dart';
import 'package:accounting/screens/auth/signUp.dart';
import 'package:accounting/services/authService.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  String emailAddress;
  String password;
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
              title: Text('Sign In', style: TextStyle(color: appBarTextColor)),
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
                              labelText: 'Email Address'),
                          validator: (val) =>
                              val.isEmpty ? 'Email is required' : null,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (val) {
                            setState(
                                () => emailAddress = val.trim().toString());
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            labelText: 'Password',
                          ),
                          validator: (val) =>
                              val.isEmpty ? 'Password is required' : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val.trim().toString());
                          },
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 50,
                          child: RaisedButton(
                            color: primaryButtonBackgroundColor,
                            elevation: 5.0,
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                  color: primaryButtonTextColor, fontSize: 18),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() => loading = true);
                                dynamic result = await _auth.signIn(
                                    emailAddress.trim(), password.trim());
                                // login call
                                if (result == null) {
                                  setState(() {
                                    error =
                                        'Invalid Credentials! Please try again';
                                    loading = false;
                                  });
                                } else {
                                  setState(() => loading = false);
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
                                text: 'Don\'t have an account yet? ',
                                style: TextStyle(
                                    color: primaryColor, fontSize: 16),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Sign Up here!',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ]),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          error,
                          style: TextStyle(color: errorColor),
                        ),
                      ],
                    ),
                  )),
            ),
          );
  }
}
