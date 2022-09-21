import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_creator_card/schedule_creator/week_picker/viewmodel/week_picker_viewmodel.dart';

final weekPickerViewModelProvider = ChangeNotifierProvider.autoDispose<WeekPickerViewModel>((ref) {
  return WeekPickerViewModel();
});
