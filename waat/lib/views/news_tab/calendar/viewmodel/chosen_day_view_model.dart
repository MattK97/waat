import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/main.dart';
import 'package:newappc/models/Schedule.dart';
import 'package:newappc/models/meeting.dart';
import 'package:newappc/models/task.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/news_tab/calendar/viewmodel/calendar_providers.dart';

class ChosenDayViewModel {
  ChosenDayViewModel({this.ref});

  Reader ref;

  List<Task> get selectedDayTaskList {
    return ref(tasksContainerNotifier)
        .taskList
        ?.where((element) => Jiffy(ref(calendarSelectedDayProvider.state).state)
            .isBetween(element.start, element.stop))
        ?.toList();
  }

  List<Meeting> get selectedDayMeetingList {
    return ref(meetingNotifier)
        .meetingList
        ?.where((element) =>
            DateFormat.yMd().format(element.start) ==
            DateFormat.yMd().format(ref(calendarSelectedDayProvider.state).state))
        ?.toList();
  }

  Schedule get selectedDayUserSchedule {
    return ref(schedulesNotifier).scheduleList?.firstWhere(
        (schedule) =>
            Jiffy(schedule.start).date ==
                Jiffy(ref(calendarSelectedDayProvider.state).state).date &&
            schedule.userID == ref(authServiceViewModel).user.uid,
        orElse: () => null);
  }

  // WorkTime get selectedDayUserWorkTime {
  //   return ref(workTimeNotifier).workTimeList?.firstWhere(
  //       (workTime) =>
  //           Jiffy(workTime.start).date == Jiffy(ref(calendarSelectedDayProvider).state).date,
  //       orElse: () => null);
  // }
}
