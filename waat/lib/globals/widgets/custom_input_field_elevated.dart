import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newappc/globals/styles/paddings.dart';

class CustomInputFieldElevated extends StatelessWidget {
  final String fieldName;
  final TextEditingController textEditingController;
  final Function(String value) notifyParent;
  final bool expanded;
  final IconData icon;
  final bool obscureText;
  final int maxLines;

  CustomInputFieldElevated(
      {this.fieldName,
      this.textEditingController,
      this.notifyParent,
      this.expanded,
      this.icon,
      this.obscureText,
      this.maxLines});
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: Padding(
            padding: inputFieldPadding,
            child: Container(
                child: TextFormField(
              onChanged: notifyParent == null ? null : (value) => notifyParent(value) ?? null,
              maxLines: maxLines,
              autofocus: false,
              obscureText: obscureText,
              minLines: expanded == null ? 1 : 10,
              controller: textEditingController,
              decoration: InputDecoration(
                prefixIcon: Icon(icon),
                border: InputBorder.none,
                hintText: fieldName,
                floatingLabelStyle: TextStyle(color: Colors.teal[400]),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: inputFieldPadding,
              ),
            ))));
  }
}
