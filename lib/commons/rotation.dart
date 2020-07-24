import 'dart:math';

import 'package:flutter/material.dart';

class Rotation extends StatelessWidget {
  static const double degree2Radians = pi / 180;

  final Widget child;
  final double rotationY;

  const Rotation({
    Key key,
    this.child,
    this.rotationY,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(rotationY * degree2Radians),
      child: child,
    );
  }
}
