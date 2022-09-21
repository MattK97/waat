import 'package:flutter/cupertino.dart';
import 'package:newappc/models/TaskContainer.dart';
import 'package:newappc/models/Team.dart';
import 'package:newappc/models/task.dart';
import 'package:newappc/rest/response/response_status.dart';
import 'package:newappc/screens/MainScreen.dart';

class TasksContainerNotifier extends ChangeNotifier {
  TasksContainerNotifier(this.team);

  List<TaskContainer> taskContainerList;

  List<Task> get taskList {
    List<Task> list = [];
    if (taskContainerList == null) return [];
    taskContainerList.forEach((element) {
      list.addAll(element?.taskList);
    });
    return list;
  }

  Team team;

  Future<void> fetchTaskContainerList() async {
    final results = await taskServices.fetchTaskContainer(team.teamId).then((value) => value.data);
    taskContainerList = results;
    notifyListeners();
  }

  Future<bool> addTaskContainer(TaskContainer taskContainer) async {
    if (taskContainer == null) return false;
    int taskContainerID = await taskServices
        .createTaskContainer(
          team.teamId,
          taskContainer,
        )
        .then((value) => value.data['object_id']);
    ;
    if (taskContainerID != null) {
      taskContainer.taskContainerID = taskContainerID;
      taskContainer.taskList = [];
      taskContainerList.add(taskContainer);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updateTaskContainerOrder(List<TaskContainer> orderedTaskContainerList) async {
    List<Map<String, int>> list = [];
    int i = 0;
    orderedTaskContainerList.forEach((element) {
      Map<String, int> taskContainersOrderMap = {};
      taskContainersOrderMap['id'] = element.taskContainerID;
      taskContainersOrderMap['order'] = i;
      list.add(taskContainersOrderMap);
      i++;
    });

    final result = await taskServices
        .updateTaskContainerOrder(team.teamId, list)
        .then((value) => value.code == ResponseStatus.valid);
    ;

    if (result) {
      taskContainerList = orderedTaskContainerList;
      taskContainerList.forEach((element) {
        element.order = taskContainerList.indexOf(element);
      });
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateTaskContainer(TaskContainer taskContainer) async {
    final taskID = await taskServices
        .updateTaskContainer(taskContainer, team.teamId)
        .then((value) => value.code == ResponseStatus.valid);
    ;
    if (taskID != null) {
      taskContainerList
          .removeWhere((element) => element.taskContainerID == taskContainer.taskContainerID);
      taskContainerList.add(taskContainer);
      taskContainerList.sort((a, b) => a.order.compareTo(b.order));
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeTaskContainer(TaskContainer taskContainer) async {
    final result = await taskServices
        .deleteTaskContainer(taskContainer, team.teamId)
        .then((value) => value.code == ResponseStatus.valid);
    ;
    if (result) {
      taskContainerList.remove(taskContainer);
      notifyListeners();
    }
  }

  Future<bool> addTask(Task task) async {
    if (task == null) return false;
    int taskID =
        await taskServices.createTask(task, team.teamId).then((value) => value.data['object_id']);
    ;
    if (taskID != null) {
      task.taskID = taskID;
      taskContainerList
          .firstWhere((element) => element.taskContainerID == task.taskContainerID)
          .taskList
          .add(task);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> changeTaskContainer(
      int oldTaskContainerId, int newTaskContainerId, Task task) async {
    final oldTaskContainer =
        taskContainerList.firstWhere((element) => element.taskContainerID == task.taskContainerID);
    oldTaskContainer.taskList.remove(task);
    task.taskContainerID = newTaskContainerId;
    updateTask(task);
    final newTaskContainer =
        taskContainerList.firstWhere((element) => element.taskContainerID == newTaskContainerId);
    newTaskContainer.taskList.add(task);
    notifyListeners();
    return true;
  }

  Future<bool> updateTask(Task task) async {
    final taskID = await taskServices
        .updateTask(task, team.teamId)
        .then((value) => value.code == ResponseStatus.valid);
    ;
    if (taskID != null) {
      taskContainerList
          .firstWhere((element) => element.taskContainerID == task.taskContainerID)
          .taskList
          .removeWhere((element) => element.taskID == task.taskID);
      taskContainerList
          .firstWhere((element) => element.taskContainerID == task.taskContainerID)
          .taskList
          .add(task);
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeTask(Task task) async {
    final result = await taskServices
        .deleteTask(task, team.teamId)
        .then((value) => value.code == ResponseStatus.valid);
    ;
    if (result) {
      taskContainerList
          .firstWhere((element) => element.taskContainerID == task.taskContainerID)
          .taskList
          .remove(task);
      notifyListeners();
    }
  }
}
