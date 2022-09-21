import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newappc/additional_widgets/color_manipulator.dart';
import 'package:newappc/additional_widgets/hex_color.dart';
import 'package:newappc/models/User.dart';

class CustomAppBar extends StatelessWidget {
  User user;
  CustomAppBar({this.user});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorManipulator.lighten(HexColor(user.color)),
      iconTheme: IconThemeData(color: ColorManipulator.darken(HexColor(user.color))),
      title: Text(user.firstName.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: ColorManipulator.darken(HexColor(user.color)),
              fontWeight: FontWeight.bold,
              fontSize: 26)),
    );
  }
}
