import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/globals/styles/paddings.dart';

class CustomDateRangePicker extends StatelessWidget {
  final DateTimeRange pickedDateTimeRange;
  final Function(DateTimeRange dateTimeRange) notifyParent;

  CustomDateRangePicker({this.pickedDateTimeRange, this.notifyParent});

  String dateRangeString(DateTimeRange dateTimeRange) {
    return '${Jiffy(dateTimeRange.start).yMMMd} - ${Jiffy(dateTimeRange.end).yMMMd}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: inputFieldPadding,
      child: InkWell(
        onTap: () async {
          final dateRange = await showDateRangePicker(
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              initialDateRange: pickedDateTimeRange,
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 100)),
              builder: (context, child) {
                return Theme(
                    data: Theme.of(context)
                        .copyWith(colorScheme: ColorScheme.light(primary: Colors.teal[400])),
                    child: child);
              });
          if (dateRange != null) {
            notifyParent(dateRange);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: AppLocalizations.of(context).date_range),
          child: pickedDateTimeRange != null
              ? Text(dateRangeString(pickedDateTimeRange))
              : Text(AppLocalizations.of(context).please_pass_date_range,
                  style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }
}
