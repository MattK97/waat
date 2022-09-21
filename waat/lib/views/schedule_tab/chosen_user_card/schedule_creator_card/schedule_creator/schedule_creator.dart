import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newappc/models/User.dart';

import 'schedule_creator_schedule_list.dart';

class ScheduleCreator extends StatelessWidget {
  final User user;
  ScheduleCreator({this.user});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        ScheduleCreatorScheduleList(user: user),
        const SizedBox(
          height: 20,
        ),
      ],
    ));
  }
}
