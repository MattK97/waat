import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newappc/globals/widgets/custom_input_field.dart';

class UserCredentials extends StatelessWidget {
  final TextEditingController firstNameController;
  final Function(String value) notifyParent;

  const UserCredentials({Key key, this.firstNameController, this.notifyParent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomInputField(
        notifyParent: notifyParent,
        fieldName: 'First Name',
        textEditingController: firstNameController,
      ),
    );
  }
}
