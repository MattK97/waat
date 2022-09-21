import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:newappc/globals/styles/paddings.dart';

class CustomTimePickerField extends StatelessWidget {
  final EdgeInsets padding;
  final Function(TimeOfDay timeOfDay) notifyParent;
  final TimeOfDay pickedTimeOfDay;

  CustomTimePickerField({this.padding, this.notifyParent, this.pickedTimeOfDay});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? inputFieldPadding,
      child: InkWell(
        onTap: () async {
          final timeOfDay = await showTimePicker(
              context: context,
              builder: (context, child) {
                return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(primary: Colors.teal[400]),
                      timePickerTheme: TimePickerThemeData(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)))),
                    ),
                    child: child);
              },
              initialTime: TimeOfDay(hour: 8, minute: 0));
          if (timeOfDay != null) {
            notifyParent(timeOfDay);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: AppLocalizations.of(context).time,
          ),
          child: pickedTimeOfDay != null
              ? Text('${pickedTimeOfDay.format(context)}')
              : Text('hh:mm', style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }
}
