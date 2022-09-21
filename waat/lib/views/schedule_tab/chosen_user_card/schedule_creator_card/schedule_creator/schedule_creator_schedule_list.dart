import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/main.dart';
import 'package:newappc/models/Schedule.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_creator_card/schedule_creator/schedule_tile.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_creator_card/schedule_creator/viewmodel/schedule_creator_providers.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_creator_card/schedule_creator/week_picker/viewmodel/week_picker_providers.dart';

import '../specific_day_screen/specific_day_screen.dart';

class ScheduleCreatorScheduleList extends ConsumerWidget {
  final User user;

  ScheduleCreatorScheduleList({this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleCreatorVM = ref.watch(scheduleCreatorViewModel);
    Map<int, Schedule> scheduleList = scheduleCreatorVM.chosenUserWeeklySchedule(user: user);
    final weeklyPicker = ref.watch(weekPickerViewModelProvider);
    final isModerator = ref
        .watch(usersNotifier)
        .userList
        .firstWhere((element) => element.userID == ref.watch(authServiceViewModel).user.uid)
        .isModerator;
    return ListView.builder(
        padding: EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 7,
        itemBuilder: (context, index) {
          final schedule = scheduleList[index];
          final dateTime = weeklyPicker.creatorVisibleDays[index];
          return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SpecificDayScreen(
                          dateTime: dateTime,
                          schedule: schedule.start == null ? null : schedule,
                          user: user,
                        )));
              },
              child: ScheduleTile(
                  dateTime: dateTime, schedule: schedule, isModerator: isModerator, user: user));
        });
  }
}
