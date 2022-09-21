import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'calendar_view_model.dart';
import 'chosen_day_view_model.dart';

final AutoDisposeStateProvider<DateTime> calendarSelectedDayProvider =
    StateProvider.autoDispose<DateTime>((_) => DateTime.now());
final AutoDisposeStateProvider<DateTime> calendarFocusedDayProvider =
    StateProvider.autoDispose<DateTime>((_) => DateTime.now());
final calendarViewModel = ChangeNotifierProvider.autoDispose<CalendarViewModel>((ref) {
  return CalendarViewModel(ref: ref.watch);
});
final chosenDayViewModel = Provider.autoDispose<ChosenDayViewModel>((ref) {
  return ChosenDayViewModel(ref: ref.watch);
});
