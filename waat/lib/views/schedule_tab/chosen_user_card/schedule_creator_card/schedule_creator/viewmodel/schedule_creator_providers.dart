import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_creator_card/schedule_creator/viewmodel/schedule_creator_view_model.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_creator_card/schedule_creator/viewmodel/user_list_dialog_viewmodel.dart';

final scheduleCreatorViewModel =
    ChangeNotifierProvider.autoDispose<ScheduleCreatorViewModel>((ref) {
  return ScheduleCreatorViewModel(ref: ref.watch);
});
final userListDialogViewModel = ChangeNotifierProvider.autoDispose<UserListDialogViewModel>((ref) {
  return UserListDialogViewModel(ref: ref.watch);
});
