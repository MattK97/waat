import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/globals/widgets/custom_confirmation_dialog.dart';
import 'package:newappc/models/Schedule.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/screens/MainScreen.dart';

class ScheduleActionIconButton extends ConsumerWidget {
  final User user;
  final Schedule schedule;
  ScheduleActionIconButton({this.user, this.schedule});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(CupertinoIcons.exclamationmark_square, color: Colors.orange),
      onPressed: () async {
        bool result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomConfirmationDialog(
                content: 'Are you sure that you want to confirm this schedule?',
                contentWidget: Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      '${Jiffy(schedule.start).MMMMEEEEd} \n${Jiffy(schedule.start).Hm} - ${Jiffy(schedule.stop).Hm}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
            });
        if (result) {
          schedule.confirmation = true;
          ref.watch(schedulesNotifier).confirmSchedules(schedule);
        }
      },
    );
  }
}
