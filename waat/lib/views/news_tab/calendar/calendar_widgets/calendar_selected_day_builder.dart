import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/globals/styles/colors.dart';
import 'package:newappc/models/Schedule.dart';
import 'package:newappc/screens/MainScreen.dart';

import '../../../../main.dart';
import 'calendar_chosen_day_schedule_pill.dart';

class CalendarSelectedDayBuilder extends ConsumerWidget {
  final DateTime date;
  CalendarSelectedDayBuilder({this.date});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesN = ref.watch(schedulesNotifier);
    final uid = ref.watch(authServiceViewModel).user.uid;
    final schedule = schedulesN.scheduleList.firstWhere(
        (element) => element.userID == uid && Jiffy(element.start).MEd == Jiffy(date).MEd,
        orElse: () => null);
    if (schedule == null) {
      return CalendarChosenDaySchedulePill(date, primaryVinted, BoxDecoration());
    } else {
      return schedule.confirmation
          ? _calendarSelectedDayBuilderChildWidget(schedule)
          : Opacity(
              child: _calendarSelectedDayBuilderChildWidget(schedule),
              opacity: 0.5,
            );
    }
  }

  Widget _calendarSelectedDayBuilderChildWidget(Schedule schedule) {
    if (schedule.holiday) {
      return CalendarChosenDaySchedulePill(
        date,
        Colors.white,
        BoxDecoration(
          color: Colors.orange[300],
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      );
    } else if (schedule.sickLeave) {
      return CalendarChosenDaySchedulePill(
        date,
        Colors.white,
        BoxDecoration(
          color: Colors.blue[600],
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      );
    } else {
      return CalendarChosenDaySchedulePill(
        date,
        Colors.white,
        BoxDecoration(
          color: primaryVinted,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      );
    }
  }
}
