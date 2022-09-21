import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/models/Schedule.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/models/meeting.dart';
import 'package:newappc/models/task.dart';
import 'package:newappc/screens/MainScreen.dart';

import 'chosen_month_card_providers.dart';

class ChosenMonthCardViewModel extends ChangeNotifier {
  ChosenMonthCardViewModel({this.ref});

  Reader ref;

  String timeFormatter(var time) {
    Duration duration = Duration(milliseconds: time.round());
    return [duration.inHours, duration.inMinutes]
            .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
            .join('h:') +
        "min";
  }

  String userScheduleTotalTime(User user) {
    var diff = 0;
    List<Schedule> userSchedules = ref(schedulesNotifier)
        .scheduleList
        ?.where((schedule) => schedule.userID == user?.userID)
        ?.toList();
    List<Schedule> thisMonthSchedules = userSchedules
        .where((schedule) =>
            Jiffy(schedule.start).month == ref(chosenMonthProvider.state).state.month &&
            schedule.confirmation)
        .toList();
    thisMonthSchedules.forEach((element) {
      diff += Jiffy(element.stop).diff(Jiffy(element.start));
    });
    return timeFormatter(diff);
  }

  List<Task> userMonthlyTaskList(User user) {
    List<Task> chosenUserTasks = ref(tasksContainerNotifier)
        .taskList
        .where((element) => element.taskUsersIds.contains(user?.userID))
        .toList();
    List<Task> monthlyTasks = chosenUserTasks
        .where((element) => element.start.month == ref(chosenMonthProvider.state).state.month)
        .toList();
    return monthlyTasks;
  }

  List<Meeting> userMonthlyMeetingList(User user) {
    List<Meeting> chosenUserMeetings = ref(meetingNotifier)
        .meetingList
        .where((element) => element.meetingUsersIds.contains(user?.userID))
        .toList();
    List<Meeting> monthlyMeetings = chosenUserMeetings
        .where((element) => element.start.month == ref(chosenMonthProvider.state).state.month)
        .toList();
    return monthlyMeetings;
  }

/*
  List<WorkTime> get choosedUserWorkTimeList {
    List<WorkTime> tempWorkTimeList = workTimeList
        .where((element) =>
    element.userID == choosenUser?.userID && element.start.month == choosenMonth)
        .toList(); //TODO dodać mieisąc
    return tempWorkTimeList;
  }

  List<Task> get choosedUserMonthlyEventList {
    List<Task> tempEventList = eventList
        ?.where((element) =>
    element.taskUsersIds.contains(choosenUser?.userID) &&
        element.start.month == choosenMonth)
        ?.toList();
    return tempEventList;
  }

  String get choosedUserScheduleTotalTime {
    var diff = 0;
    scheduleList
        ?.where((schedule) => schedule.userID == choosenUser?.userID)
        ?.toList()
        ?.where((schedule) => Jiffy(schedule.start).month == choosenMonth && schedule.confirmation)
        ?.forEach((element) {
      diff += Jiffy(element.stop).diff(Jiffy(element.start));
    });
    return timeFormatter(diff);
  }

  String get choosenUserWorkTimeTotalTime {
    var diff = 0;
    workTimeList
        .where((element) =>
    element.userID == choosenUser?.userID && Jiffy(element.start).month == choosenMonth)
        .forEach((element) {
      diff += Jiffy(element.stop).diff(Jiffy(element.start));
    });
    return timeFormatter(diff);
  }

 */

}
