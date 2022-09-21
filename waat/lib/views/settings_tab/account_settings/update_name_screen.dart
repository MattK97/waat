import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/widgets/custom_action_button.dart';
import 'package:newappc/globals/widgets/custom_input_field.dart';
import 'package:newappc/screens/MainScreen.dart';

enum TypeEnum { name, lastName }

class UpdateName extends StatefulWidget {
  final TypeEnum typeEnum;

  UpdateName({this.typeEnum});

  @override
  _UpdateNameState createState() => _UpdateNameState();
}

class _UpdateNameState extends State<UpdateName> {
  final textController = TextEditingController();
  bool _isButtonDisabled = true;

  void _updateButton(String value) {
    setState(() {
      _isButtonDisabled = textController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.teal[400],
            title: Text(
              widget.typeEnum == TypeEnum.name
                  ? AppLocalizations.of(context).update_name.toUpperCase()
                  : AppLocalizations.of(context).update_last_name.toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          body: ListView(
            children: [
              SizedBox(
                height: 32,
              ),
              CustomInputField(
                notifyParent: _updateButton,
                fieldName: widget.typeEnum == TypeEnum.name
                    ? AppLocalizations.of(context).first_name
                    : AppLocalizations.of(context).last_name,
                textEditingController: textController,
              ),
              CustomActionButton(
                disabled: _isButtonDisabled,
                onPressed: () async {
                  widget.typeEnum == TypeEnum.name
                      ? await ref.watch(usersNotifier).updateUserFirstName(textController.text)
                      : await ref.watch(usersNotifier).updateUserFirstName(textController.text);
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      );
    });
  }
}
