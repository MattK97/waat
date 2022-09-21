import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newappc/globals/styles/paddings.dart';
import 'package:newappc/globals/styles/radiuses.dart';

class CustomInputField extends StatelessWidget {
  final String fieldName;
  final TextEditingController textEditingController;
  final Function(String value) notifyParent;
  final bool expanded;

  CustomInputField({this.fieldName, this.textEditingController, this.notifyParent, this.expanded});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: inputFieldPadding,
        child: Container(
            child: TextFormField(
          onChanged: notifyParent == null ? null : (value) => notifyParent(value) ?? null,
          maxLines: null,
          autofocus: false,
          minLines: expanded == null ? 1 : 10,
          controller: textEditingController,
          decoration: InputDecoration(
            focusedBorder: new OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: Colors.teal[400]),
            ),
            floatingLabelStyle: TextStyle(color: Colors.teal[400]),
            border: OutlineInputBorder(borderRadius: borderRadius),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: fieldName,
            contentPadding: inputFieldPadding,
          ),
        )));
  }
}
