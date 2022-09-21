import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:newappc/globals/styles/colors.dart';
import 'package:newappc/globals/styles/radiuses.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String content;
  final Widget contentWidget;

  CustomConfirmationDialog({this.content, this.contentWidget});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 8,
          ),
          contentWidget
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              AppLocalizations.of(context).confirm,
              style: TextStyle(color: primaryTeal),
            )),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context).cancel, style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}
