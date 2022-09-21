import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';

final AutoDisposeStateProvider scheduleCalendarVisibleDaysProvider =
    StateProvider.autoDispose<List<DateTime>>((_) {
  List<DateTime> list = [];
  for (int i = 0; i < 7; i++) {
    var weekday = Jiffy(Jiffy().startOf(Units.WEEK)).add(days: i);
    list.add(weekday.dateTime);
  }
  return list;
});
