import 'package:flutter/cupertino.dart';

class CalendarChosenDaySchedulePill extends StatelessWidget {
  final decoration, fontColor, date;

  CalendarChosenDaySchedulePill(this.date, this.fontColor, this.decoration);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: decoration,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: fontColor)),
            child: Text(
              '${date.day}',
              style: TextStyle(color: fontColor).copyWith(fontSize: 16.0),
            ),
          ),
        ));
  }
}
