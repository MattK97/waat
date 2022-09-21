import 'package:flutter/cupertino.dart';

class CalendarChosenDaySchedulePillNoBorder extends StatelessWidget {
  final decoration, fontColor, date;

  CalendarChosenDaySchedulePillNoBorder(this.date, this.fontColor, this.decoration);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: decoration,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Text(
              '${date.day}',
              style: TextStyle(color: fontColor).copyWith(fontSize: 16.0),
            ),
          ),
        ));
  }
}
