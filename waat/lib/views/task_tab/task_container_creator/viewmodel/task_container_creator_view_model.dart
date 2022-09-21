import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/models/TaskContainer.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/task_tab/task_tab.dart';

class TaskContainerCreatorViewModel extends ChangeNotifier {
  TaskContainerCreatorViewModel({this.ref});

  Reader ref;

  void operateOnTaskContainer({TaskContainer chosenTaskContainer, String name, int order}) =>
      chosenTaskContainer == null
          ? _addNewTaskContainer(name: name, order: order)
          : _updateTaskContainer(chosenTaskContainer: chosenTaskContainer, name: name);

  Future<void> _addNewTaskContainer({String name, int order}) async {
    TaskContainer taskContainer = TaskContainer(
        name: name,
        teamId: ref(chosenTeamProvider.state).state.teamId,
        taskContainerID: null,
        created: DateTime.now().toUtc(),
        taskList: [],
        order: order);
    if (await ref(tasksContainerNotifier).addTaskContainer(taskContainer)) {
      ref(taskTabMainWidgetProvider.state).state = TasksTab();
    }
  }

  Future<void> _updateTaskContainer({TaskContainer chosenTaskContainer, String name}) async {
    TaskContainer taskContainer = TaskContainer(
        name: name,
        teamId: chosenTaskContainer.teamId,
        taskContainerID: chosenTaskContainer.taskContainerID,
        created: chosenTaskContainer.created,
        taskList: chosenTaskContainer.taskList,
        order: chosenTaskContainer.order);
    if (await ref(tasksContainerNotifier).updateTaskContainer(taskContainer)) {
      ref(taskTabMainWidgetProvider.state).state = TasksTab();
    }
  }
}
