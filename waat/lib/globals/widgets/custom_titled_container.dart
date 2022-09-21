import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:newappc/globals/styles/colors.dart';
import 'package:newappc/globals/styles/paddings.dart';
import 'package:newappc/globals/styles/radiuses.dart';

class CustomTitledContainer extends StatelessWidget {
  final Widget customSectionTitle;
  final Widget child;
  final Color color;

  CustomTitledContainer({this.customSectionTitle, this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        customSectionTitle,
        Padding(
          padding: allSixteen,
          child: Neumorphic(
            child: Container(
                decoration: BoxDecoration(
                    color: color == null ? Colors.white : color,
                    borderRadius: borderRadius,
                    border: Border.all(color: borderColor)),
                child: child),
          ),
        ),
      ],
    );
  }
}
