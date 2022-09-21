import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/models/Schedule.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_creator_card/schedule_creator/week_picker/viewmodel/week_picker_providers.dart';

class UserListDialogViewModel extends ChangeNotifier {
  UserListDialogViewModel({this.ref});

  Reader ref;

  List<Schedule> generateCopiedSchedule({User chosenUserToDuplicateFrom, User user}) {
    List<Schedule> duplicatedScheduleList = List<Schedule>();
    final scheduleListToDuplicate = ref(schedulesNotifier)
        .scheduleList
        .where((element) =>
            element.userID == chosenUserToDuplicateFrom.userID &&
            (Jiffy(element.start).isSameOrAfter(
                    ref(weekPickerViewModelProvider).creatorVisibleDays.first, Units.DAY) &&
                Jiffy(element.stop).isSameOrBefore(ref(weekPickerViewModelProvider).creatorVisibleDays.last, Units.DAY)))
        .toList();
    for (Schedule schedule in scheduleListToDuplicate) {
      final destinationDayDate = Jiffy(schedule.start).dateTime;
      final pointedDaySchedule = ref(schedulesNotifier)
          .scheduleList.firstWhere(
          (element) =>
              Jiffy(element.start).MEd == Jiffy(destinationDayDate).MEd &&
              element.userID == user.userID,
          orElse: () => null);
      final duplicatedSchedule = new Schedule(
          id: pointedDaySchedule == null ? null : pointedDaySchedule.id,
          start: schedule.start,
          stop: schedule.stop,
          confirmation: schedule.confirmation,
          sickLeave: schedule.sickLeave,
          holiday: schedule.holiday,
          userID: user.userID,
          teamID: schedule.teamID);
      duplicatedScheduleList.add(duplicatedSchedule);
    }
    return duplicatedScheduleList;
  }
}
