import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/models/Schedule.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_creator_card/schedule_creator/week_picker/viewmodel/week_picker_providers.dart';

class ScheduleCreatorViewModel extends ChangeNotifier {
  ScheduleCreatorViewModel({this.ref});

  Reader ref;

  List<Schedule> _tempScheduleList = [];
  List<Schedule> get tempScheduleList => _tempScheduleList;
  set tempScheduleList(List<Schedule> value) {
    _tempScheduleList = value;
    notifyListeners();
  }

  Map<int, Schedule> chosenUserWeeklySchedule({User user}) {
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

    List<Schedule> chosenWeekSchedule = ref(schedulesNotifier)
        .scheduleList
        ?.where((schedule) => schedule.userID == user.userID)
        ?.toList()
        ?.where((element) => (Jiffy(element.start).isSameOrAfter(
                ref(weekPickerViewModelProvider).creatorVisibleDays.first, Units.DAY) &&
            Jiffy(element.stop).isSameOrBefore(
                ref(weekPickerViewModelProvider).creatorVisibleDays.last, Units.DAY)))
        ?.toList();
    chosenWeekSchedule?.forEach((element) {
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

  /* List<int> generateScheduleListToConfirm() {
    List<int> scheduleList;
    chosenUserWeeklySchedule.forEach((key, schedule) {
      if (schedule.start != null && !schedule.confirmation) {
        scheduleList.add(schedule.id);
      }
    });
    return scheduleList;
  }

  */

  String timeFormatter(var time) {
    Duration duration = Duration(milliseconds: time.round());
    return [duration.inHours, duration.inMinutes]
            .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
            .join('h:') +
        "min";
  }
}
