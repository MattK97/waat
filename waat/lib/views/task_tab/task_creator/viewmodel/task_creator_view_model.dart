import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/models/TaskContainer.dart';
import 'package:newappc/models/task.dart';
import 'package:newappc/models/user_checkbox_item.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/task_tab/task_tab.dart';

import '../../../../main.dart';

class TaskCreatorViewModel extends ChangeNotifier {
  TaskCreatorViewModel({this.ref});

  Reader ref;

  void operateOnTask(
          {Task chosenTask,
          String title,
          String info,
          DateTimeRange dateTimeRange,
          TaskContainer taskContainer,
          List<UserCheckboxItem> chosenUsers}) =>
      chosenTask == null
          ? _addNewTask(
              title: title,
              info: info,
              startDateTime: dateTimeRange.start,
              stopDateTime: dateTimeRange.end,
              chosenUsers: chosenUsers,
              taskContainer: taskContainer)
          : _updateTask(
              chosenTask: chosenTask,
              title: title,
              info: info,
              startDateTime: dateTimeRange.start,
              stopDateTime: dateTimeRange.end,
              chosenUsers: chosenUsers,
              taskContainer: taskContainer);

  Future<void> _addNewTask(
      {String title,
      String info,
      DateTime startDateTime,
      DateTime stopDateTime,
      TaskContainer taskContainer,
      List<UserCheckboxItem> chosenUsers}) async {
    Task generatedTask = Task(
        creatorID: ref(authServiceViewModel).user.uid,
        taskID: null,
        start: startDateTime,
        stop: stopDateTime,
        name: title,
        info: info,
        taskUsersIds: chosenUsers
            .where((element) => element.isSelected)
            .map<String>((e) => e.user.userID)
            .toList(),
        teamId: ref(chosenTeamProvider.state).state.teamId,
        isPublic: true,
        taskContainerID: taskContainer.taskContainerID);
    if (await ref(tasksContainerNotifier).addTask(generatedTask)) {
      ref(taskTabMainWidgetProvider.state).state = TasksTab();
    }
  }

  Future<void> _updateTask(
      {Task chosenTask,
      String title,
      String info,
      DateTime startDateTime,
      DateTime stopDateTime,
      TaskContainer taskContainer,
      List<UserCheckboxItem> chosenUsers}) async {
    Task generatedTask = Task(
        taskID: chosenTask.taskID,
        start: startDateTime,
        stop: stopDateTime,
        name: title,
        info: info,
        taskUsersIds: chosenUsers
            .where((element) => element.isSelected)
            .map<String>((e) => e.user.userID)
            .toList(),
        teamId: chosenTask.teamId,
        isPublic: chosenTask.isPublic,
        taskContainerID: taskContainer.taskContainerID);
    if (await ref(tasksContainerNotifier).updateTask(generatedTask)) {
      ref(taskTabMainWidgetProvider.state).state = TasksTab();
    }
  }
}
