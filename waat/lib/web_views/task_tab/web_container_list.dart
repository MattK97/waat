import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/models/TaskContainer.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/web_views/task_tab/web_task_container_widget.dart';

final webTaskContainerWidgetsProvider =
    StateProvider.autoDispose<List<WebTaskContainerWidget>>((ref) {
  List<WebTaskContainerWidget> taskContainerWidgets = [];
  final taskContainerList = ref.watch(tasksContainerNotifier).taskContainerList;
  for (TaskContainer taskContainer in taskContainerList) {
    WebTaskContainerWidget taskContainerWidget =
        WebTaskContainerWidget(taskContainer: taskContainer);
    taskContainerWidgets.add(taskContainerWidget);
  }
  return taskContainerWidgets;
});

class WebContainerList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webTaskContainerWidgets = ref.watch(webTaskContainerWidgetsProvider.state);
    webTaskContainerWidgets.state
        .sort((a, b) => a.taskContainer.order.compareTo(b.taskContainer.order));
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: webTaskContainerWidgets.state.map((e) => e).toList());
  }
}
