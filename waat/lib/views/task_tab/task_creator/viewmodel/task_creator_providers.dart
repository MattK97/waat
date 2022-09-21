import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/views/task_tab/task_creator/viewmodel/task_creator_view_model.dart';

final taskCreatorViewModel = ChangeNotifierProvider<TaskCreatorViewModel>((ref) {
  return TaskCreatorViewModel(ref: ref.read);
});
