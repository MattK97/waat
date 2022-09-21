import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTitledContainerNoBorder extends StatelessWidget {
  final Widget customSectionTitle;
  final Widget child;

  CustomTitledContainerNoBorder({this.customSectionTitle, this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        customSectionTitle,
        child,
      ],
    );
  }
}
