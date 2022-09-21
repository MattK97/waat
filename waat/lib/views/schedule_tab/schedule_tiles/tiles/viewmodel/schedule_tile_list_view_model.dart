import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/models/Schedule.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/schedule_tab/schedule_tiles/calendar/viewmodel/schedule_calendar_providers.dart';

class ScheduleTileListViewModel {
  ScheduleTileListViewModel({this.ref});

  Reader ref;

  Map<int, Schedule> createSpecificUserWeeklySchedule(User user) {
    Map<int, Schedule> map = {
      0: Schedule(
          id: null, start: null, stop: null, confirmation: false, sickLeave: false, holiday: false),
      1: Schedule(
          id: null, start: null, stop: null, confirmation: false, sickLeave: false, holiday: false),
      2: Schedule(
          id: null, start: null, stop: null, confirmation: false, sickLeave: false, holiday: false),
      3: Schedule(
          id: null, start: null, stop: null, confirmation: false, sickLeave: false, holiday: false),
      4: Schedule(
          id: null, start: null, stop: null, confirmation: false, sickLeave: false, holiday: false),
      5: Schedule(
          id: null, start: null, stop: null, confirmation: false, sickLeave: false, holiday: false),
      6: Schedule(
          id: null, start: null, stop: null, confirmation: false, sickLeave: false, holiday: false)
    };
    if (user == null) return map;

    List<Schedule> userSchedules = ref(schedulesNotifier)
        .scheduleList
        .where((element) => (element.userID == user.userID))
        ?.toList();

    List<Schedule> chosenWeekUserSchedule = userSchedules.where((element) {
      return (Jiffy(element.start).isBetween(
          ref(scheduleCalendarVisibleDaysProvider.state).state.first,
          Jiffy(ref(scheduleCalendarVisibleDaysProvider.state).state.last).add(days: 1),
          Units.MILLISECOND));
    })?.toList();

    chosenWeekUserSchedule?.forEach((element) {
      int dayNumber = element.start.weekday - 1;
      map[dayNumber] = Schedule(
          id: element.id,
          start: element.start,
          stop: element.stop,
          userID: element.userID,
          confirmation: element.confirmation,
          sickLeave: element.sickLeave,
          holiday: element.holiday);
    });
    return map;
  }
}
