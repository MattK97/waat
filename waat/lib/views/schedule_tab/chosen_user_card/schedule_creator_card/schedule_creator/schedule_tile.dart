import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/globals/widgets/custom_two_line_text.dart';
import 'package:newappc/models/Schedule.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_creator_card/schedule_creator/schedule_action_icon_button.dart';

class ScheduleTile extends StatelessWidget {
  final Schedule schedule;
  final bool isModerator;
  final DateTime dateTime;
  final User user;

  ScheduleTile({this.schedule, this.dateTime, this.isModerator, this.user});

  Widget _getScheduleInteractionWidget(BuildContext context) {
    if (schedule.confirmation || schedule.start == null) {
      return IconButton(
        icon: Icon(CupertinoIcons.exclamationmark_square, color: Colors.transparent),
        onPressed: null,
      );
    } else if (isModerator && !schedule.confirmation) {
      return ScheduleActionIconButton(user: user, schedule: schedule);
    } else if (!isModerator && !schedule.confirmation) {
      return IconButton(
        icon: Icon(CupertinoIcons.question_diamond, color: Colors.grey),
        onPressed: null,
      );
    }
    return IconButton(
      icon: Icon(CupertinoIcons.exclamationmark_square, color: Colors.transparent),
      onPressed: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(mainAxisSize: MainAxisSize.max, children: [
              Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.calendar_today,
                        color: Colors.teal[600],
                      ),
                      const VerticalDivider(),
                      Expanded(
                        child: Text(
                          Jiffy(dateTime).MMMEd.toUpperCase(),
                        ),
                      )
                    ],
                  )),
              const Expanded(child: VerticalDivider(), flex: 3),
              //TODO add count flex value based on screen width
              Expanded(
                child: CustomTwoLineText(
                  schedule: schedule,
                  negativeColor: true,
                ),
                flex: 2,
              ),
              _getScheduleInteractionWidget(context),
              Expanded(
                child: Icon(
                  CupertinoIcons.chevron_right,
                  color: Colors.grey[400],
                ),
                flex: 1,
              ),
            ]),
            Divider(
              thickness: 1,
            )
          ],
        ),
      ),
    );
  }
}
