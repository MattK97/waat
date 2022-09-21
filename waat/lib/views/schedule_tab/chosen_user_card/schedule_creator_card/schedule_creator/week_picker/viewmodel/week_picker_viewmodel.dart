import 'package:flutter/cupertino.dart';
import 'package:jiffy/jiffy.dart';

class WeekPickerViewModel extends ChangeNotifier {
  WeekPickerViewModel() {
    creatorVisibleDays = setCreatorVisibleDays();
    choosedWeekDatesRange = "${Jiffy(Jiffy(creatorVisibleDays.first).startOf(Units.WEEK)).MMMd} - "
        "${Jiffy(Jiffy(creatorVisibleDays.first).endOf(Units.WEEK)).MMMd}";
  }

  static List<DateTime> setCreatorVisibleDays() {
    List<DateTime> list = [];
    for (int i = 0; i < 7; i++) {
      var weekday = Jiffy(Jiffy().startOf(Units.WEEK)).add(days: i);
      list.add(weekday.dateTime);
    }
    return list;
  }

  void setDefaultVisibleDays() {
    List<DateTime> list = [];
    for (int i = 0; i < 7; i++) {
      var weekday = Jiffy(Jiffy().startOf(Units.WEEK)).add(days: i);
      list.add(weekday.dateTime);
    }
    creatorVisibleDays = list;
    notifyListeners();
  }

  String choosedWeekDatesRange;
  List<DateTime> creatorVisibleDays;

  void nextWeek() {
    DateTime currentWeekStart = creatorVisibleDays.first;
    DateTime nextWeekStart = Jiffy(currentWeekStart).add(weeks: 1).dateTime;
    List<DateTime> list = List<DateTime>();
    for (int i = 0; i < 7; i++) {
      var weekday = Jiffy(nextWeekStart).add(days: i);
      list.add(weekday.dateTime);
    }
    creatorVisibleDays = list;
    choosedWeekDatesRange = "${Jiffy(Jiffy(creatorVisibleDays.first).startOf(Units.WEEK)).MMMd} -  "
        "${Jiffy(Jiffy(creatorVisibleDays.first).endOf(Units.WEEK)).MMMd}";
    notifyListeners();
  }

  void previousWeek() {
    DateTime currentWeekStart = creatorVisibleDays.first;
    DateTime previousWeekStart = Jiffy(currentWeekStart).subtract(weeks: 1).dateTime;
    List<DateTime> list = List<DateTime>();
    for (int i = 0; i < 7; i++) {
      var weekday = Jiffy(previousWeekStart).add(days: i);
      list.add(weekday.dateTime);
    }
    creatorVisibleDays = list;
    choosedWeekDatesRange = "${Jiffy(Jiffy(creatorVisibleDays.first).startOf(Units.WEEK)).MMMd} - "
        "${Jiffy(Jiffy(creatorVisibleDays.first).endOf(Units.WEEK)).MMMd}";
    notifyListeners();
  }
}
