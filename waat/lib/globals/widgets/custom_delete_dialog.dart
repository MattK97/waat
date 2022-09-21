import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:newappc/globals/styles/radiuses.dart';

class CustomDeleteDialog extends StatelessWidget {
  final String content;
  CustomDeleteDialog({this.content});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      content: Text(
        content,
        style: TextStyle(fontSize: 16),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              AppLocalizations.of(context).delete,
              style: TextStyle(color: Colors.red),
            )),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context).cancel, style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}
