import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/views/task_tab/task_container_creator/viewmodel/task_container_creator_view_model.dart';

final taskContainerCreatorViewModelProvider =
    ChangeNotifierProvider.autoDispose<TaskContainerCreatorViewModel>((ref) {
  return TaskContainerCreatorViewModel(ref: ref.watch);
});
