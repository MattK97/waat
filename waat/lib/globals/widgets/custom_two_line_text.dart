import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/models/Schedule.dart';

class CustomTwoLineText extends StatelessWidget {
  final Schedule schedule;
  final bool negativeColor;

  CustomTwoLineText({this.schedule, this.negativeColor});

  String createReadableTimeString(Schedule schedule) {
    if (schedule.holiday) return "OFF"; //TODO add localization
    if (schedule.sickLeave) return "SL";

    String start = schedule.start.toString();
    String stop = schedule.stop.toString();
    if (start == null) return " ";
    try {
      return "${Jiffy(start).Hm}\n${Jiffy(stop).Hm}";
    } catch (e) {
      return " ";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(createReadableTimeString(schedule),
        style: negativeColor == null || !negativeColor
            ? schedule.confirmation
                ? TextStyle(fontSize: 14, color: Colors.white)
                : TextStyle(fontSize: 14, color: Colors.grey[300])
            : schedule.confirmation
                ? TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)
                : TextStyle(fontSize: 14, color: Colors.grey[400]));
  }
}
