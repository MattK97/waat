import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/main.dart';
import 'package:newappc/models/Schedule.dart';
import 'package:newappc/models/meeting.dart';
import 'package:newappc/models/task.dart';
import 'package:newappc/screens/MainScreen.dart';

class CalendarViewModel extends ChangeNotifier {
  CalendarViewModel({this.ref});

  Reader ref;
  List<dynamic> selectedDayTaskAndMeetingList = [];

  bool hasScheduleForGivenDay(DateTime day) {
    Schedule schedule = ref(schedulesNotifier).scheduleList.firstWhere(
        (element) =>
            Jiffy(element.start).yMd == Jiffy(day).yMd &&
            element.userID == ref(authServiceViewModel).user.uid,
        orElse: () => null);
    return schedule == null ? false : true;
  }

  List<dynamic> getTasksAndMeetingsForDay(DateTime day) {
    // Implementation example
    List<Task> taskListToCombine = ref(tasksContainerNotifier)
            .taskList
            .where((element) => Jiffy(day).isBetween(element.start, element.stop))
            .toList() ??
        [];
    List<Meeting> meetingListToCombine = ref(meetingNotifier)
            .meetingList
            .where((element) => Jiffy(element.start).yMd == Jiffy(day).yMd)
            .toList() ??
        [];
    return new List.from(taskListToCombine)..addAll(meetingListToCombine);
    ;
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    selectedDayTaskAndMeetingList = getTasksAndMeetingsForDay(selectedDay);
    notifyListeners();
  }
}
