import 'package:flutter/material.dart';

Color primaryColor = Color(0xff24527a);
Color errorColor = Colors.red;
Color primaryLightColor = Color(0xff567ea9);
Color secondaryColor = Color(0xff267c8d);
Color darkPrimaryColor = Color(0xff002a4e);

Color screenBackgroundColor = Colors.grey[50];
Color appBarBackgroundColor = primaryColor;
Color appBarTextColor = Colors.white;
Color primaryButtonBackgroundColor = primaryColor;
Color primaryButtonTextColor = Colors.white;
Color bottomBarDefaultColor = Colors.white;
Color bottomBarSelectedColor = secondaryColor;
Color bottomBarBackgroundColor = Colors.grey[200];
Color dividerColor = Colors.grey[300];
Color textInputBorderColor = Colors.grey[400];
final double appBarElevation = 5.0;

InputDecoration textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    isDense: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: textInputBorderColor, width: 1.0)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 1.0)));

appBarWidget(BuildContext context, String heading) {
  return AppBar(
    backgroundColor: appBarBackgroundColor,
    title: Text(heading, style: TextStyle(color: appBarTextColor)),
    elevation: appBarElevation,
  );
}

showSimpleDialogBox(BuildContext context, String message, bool popScreen) {
  SimpleDialog simpleDialog = SimpleDialog(
    title: Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
      ),
    ),
    children: <Widget>[
      Container(
        padding: EdgeInsets.fromLTRB(60, 0, 20, 0),
        alignment: Alignment.bottomRight,
        child: FlatButton(
          onPressed: () {
            Navigator.pop(context);
            if (popScreen) Navigator.pop(context);
          },
          child: Text(
            'Dismiss',
            style: TextStyle(color: primaryColor),
          ),
          color: Colors.white,
        ),
      )
    ],
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return simpleDialog;
      });
}

showAlertDialog(BuildContext context, String message, String heading) {
  AlertDialog alertDialog = AlertDialog(
    title: Text(heading),
    content: Text(message),
    actions: <Widget>[
      FlatButton(
        child: Text('Close'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )
    ],
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}

showProgressDialog(BuildContext context, String title) {
  try {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
                Flexible(
                    flex: 8,
                    child: Text(
                      title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          );
        });
  } catch (e) {
    print(e.toString());
  }
}

// collections
final String USERS_COLLECTION = 'users';
final String VENDORS_COLLECTION = 'vendors';
final String EXPENSES_COLLECTION = 'expenses';

// constants
final String EMAIL = 'email';
final String USERID = 'userid';
final String FULLNAME = 'businessname';
