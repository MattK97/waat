import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_creator_card/specific_day_screen/viewmodel/specific_day_screen_viewmodel.dart';

final specificDayScreenViewModel =
    ChangeNotifierProvider.autoDispose<SpecificDayScreenViewModel>((ref) {
  return SpecificDayScreenViewModel(ref: ref.watch);
});
