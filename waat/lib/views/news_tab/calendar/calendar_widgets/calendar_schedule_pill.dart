import 'package:flutter/cupertino.dart';

class CalendarSchedulePill extends StatelessWidget {
  final decoration, fontColor, date;

  CalendarSchedulePill(this.date, this.fontColor, this.decoration);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: decoration,
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(color: fontColor).copyWith(fontSize: 16.0),
          ),
        ));
  }
}
