import 'package:accounting/commons/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryColor,
      child: Center(
        child: SpinKitRotatingPlain(
          color: primaryColor,
          size: 50.0,
        ),
      ),
    );
  }
}
