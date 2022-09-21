import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/main.dart';
import 'package:newappc/models/Schedule.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/models/date_time_checkbox_item.dart';
import 'package:newappc/screens/MainScreen.dart';

class SpecificDayScreenViewModel extends ChangeNotifier {
  SpecificDayScreenViewModel({this.ref});

  Reader ref;

  Future<bool> operateOnSchedule(
      {Schedule chosenSchedule,
      User user,
      DateTime start,
      DateTime stop,
      bool isHoliday,
      bool isSickLeave,
      List<DateTimeCheckboxItem> dateTimeCheckedItemList}) async {
    await chosenSchedule == null
        ? _addNewSchedule(
            user: user, start: start, stop: stop, isHoliday: isHoliday, isSickLeave: isSickLeave)
        : _updateSchedule(
            chosenSchedule: chosenSchedule,
            user: user,
            start: start,
            stop: stop,
            isHoliday: isHoliday,
            isSickLeave: isSickLeave);
    dateTimeCheckedItemList
        .where((element) => Jiffy(element.dateTime).yMd != Jiffy(start).yMd)
        .forEach((dateTimeCheckedItem) async {
      final foundSchedule = ref(schedulesNotifier).scheduleList.firstWhere(
          (element) =>
              element.userID == ref(authServiceViewModel).user.uid &&
              Jiffy(element.start).yMd == Jiffy(dateTimeCheckedItem.dateTime).yMd,
          orElse: () => null);
      final DateTime modifiedStart = DateTime(
          dateTimeCheckedItem.dateTime.year,
          dateTimeCheckedItem.dateTime.month,
          dateTimeCheckedItem.dateTime.day,
          start.hour,
          start.minute);
      final DateTime modifiedStop = DateTime(
          dateTimeCheckedItem.dateTime.year,
          dateTimeCheckedItem.dateTime.month,
          dateTimeCheckedItem.dateTime.day,
          stop.hour,
          stop.minute);
      bool isGood = foundSchedule == null
          ? await _addNewSchedule(
              user: user,
              start: modifiedStart,
              stop: modifiedStop,
              isHoliday: isHoliday,
              isSickLeave: isSickLeave)
          : await _updateSchedule(
              chosenSchedule: foundSchedule,
              user: user,
              start: modifiedStart,
              stop: modifiedStop,
              isHoliday: isHoliday,
              isSickLeave: isSickLeave);
      if (!isGood) return false;
    });
    return true;
  }

  Future<bool> _addNewSchedule({
    User user,
    DateTime start,
    DateTime stop,
    bool isHoliday,
    bool isSickLeave,
  }) async {
    final schedule = new Schedule(
        id: null,
        start: start,
        stop: stop,
        confirmation: ref(isModeratorProvider.state).state ? true : false,
        holiday: isHoliday,
        sickLeave: isSickLeave,
        userID: user.userID,
        teamID: ref(chosenTeamProvider.state).state.teamId);
    if (await ref(schedulesNotifier).createSchedule(schedule)) {
      return true;
    }
    return false;
  }

  Future<bool> _updateSchedule({
    Schedule chosenSchedule,
    User user,
    DateTime start,
    DateTime stop,
    bool isHoliday,
    bool isSickLeave,
  }) async {
    final schedule = new Schedule(
        id: chosenSchedule.id,
        start: start,
        stop: stop,
        confirmation: ref(isModeratorProvider.state).state ? true : false,
        holiday: isHoliday,
        sickLeave: isSickLeave,
        userID: user.userID,
        teamID: ref(chosenTeamProvider.state).state.teamId);
    if (await ref(schedulesNotifier).updateSchedule(schedule)) {
      return true;
    }
    return false;
  }
}
