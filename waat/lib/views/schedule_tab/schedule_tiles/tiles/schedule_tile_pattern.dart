import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newappc/additional_widgets/color_manipulator.dart';
import 'package:newappc/additional_widgets/hex_color.dart';
import 'package:newappc/globals/widgets/custom_two_line_text.dart';
import 'package:newappc/models/Schedule.dart';
import 'package:newappc/models/User.dart';

//This widget creates shape of schedule, after data is received it fills it with it

class ScheduleTilePattern extends StatelessWidget {
  final Map<int, Schedule> map;
  final User user;
  ScheduleTilePattern({this.map, this.user});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: <Widget>[
        Expanded(
          child: Center(
            child: SizedBox(
                child: Container(
              child: CustomTwoLineText(schedule: map[0]),
            )),
          ),
        ),
        Container(
          height: 40,
          width: 1,
          color: ColorManipulator.darken(HexColor(user?.color), 0.3),
        ),
        Expanded(
          child: Center(
            child: CustomTwoLineText(schedule: map[1]),
          ),
        ),
        Container(
          height: 40,
          width: 1,
          color: ColorManipulator.darken(HexColor(user?.color), 0.23),
        ),
        Expanded(
          child: Center(
            child: SizedBox(child: CustomTwoLineText(schedule: map[2])),
          ),
        ),
        Container(
          height: 40,
          width: 1,
          color: ColorManipulator.darken(HexColor(user?.color), 0.23),
        ),
        Expanded(
          child: Center(
            child: SizedBox(child: CustomTwoLineText(schedule: map[3])),
          ),
        ),
        Container(
          height: 40,
          width: 1,
          color: ColorManipulator.darken(HexColor(user?.color), 0.23),
        ),
        Expanded(
          child: Center(
            child: SizedBox(child: CustomTwoLineText(schedule: map[4])),
          ),
        ),
        Container(
          height: 40,
          width: 1,
          color: ColorManipulator.darken(HexColor(user?.color), 0.23),
        ),
        Expanded(
          child: Center(
            child: SizedBox(child: CustomTwoLineText(schedule: map[5])),
          ),
        ),
        Container(
          height: 40,
          width: 1,
          color: ColorManipulator.darken(HexColor(user?.color), 0.23),
        ),
        Expanded(
          child: Center(
            child: SizedBox(child: CustomTwoLineText(schedule: map[6])),
          ),
        ),
      ]),
    );
  }
}
