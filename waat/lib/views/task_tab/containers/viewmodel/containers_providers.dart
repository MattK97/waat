import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/models/TaskContainer.dart';
import 'package:newappc/screens/MainScreen.dart';

import '../task_container_widget.dart';

final containerCarouselIndicatorProvider = StateProvider.autoDispose<int>((_) => 0);
final carouselControllerProvider =
    Provider.autoDispose<CarouselController>((_) => CarouselController());
final taskContainerWidgetsProvider = StateProvider.autoDispose<List<TaskContainerWidget>>((ref) {
  List<TaskContainerWidget> taskContainerWidgets = [];
  final taskContainerList = ref.watch(tasksContainerNotifier).taskContainerList;
  for (TaskContainer taskContainer in taskContainerList) {
    TaskContainerWidget taskContainerWidget = TaskContainerWidget(taskContainer: taskContainer);
    taskContainerWidgets.add(taskContainerWidget);
  }
  return taskContainerWidgets;
});
