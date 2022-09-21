import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/globals/styles/paddings.dart';

class CustomDatePickerField extends StatelessWidget {
  final EdgeInsets padding;
  final Function(DateTime dateTime) notifyParent;
  final DateTime pickedDateTime;

  CustomDatePickerField({this.padding, this.notifyParent, this.pickedDateTime});
  String dateString(DateTime dateTime) {
    return '${Jiffy(dateTime).yMMMd}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? inputFieldPadding,
      child: InkWell(
        onTap: () async {
          final dateTime = await showDatePicker(
            initialDate: DateTime.now(),
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 100)),
            builder: (context, child) {
              return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(primary: Colors.teal[400]),
                    dialogTheme: const DialogTheme(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)))),
                  ),
                  child: child);
            },
          );
          if (dateTime != null) {
            notifyParent(dateTime);
          }
        },
        child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: AppLocalizations.of(context).date,
            ),
            child: pickedDateTime != null
                ? Text(dateString(pickedDateTime))
                : Text('dd/mm/yyyy', style: TextStyle(color: Colors.grey))),
      ),
    );
  }
}
