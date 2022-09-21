import 'package:newappc/globals/utils/date_utils.dart';

import 'task.dart';

class TaskContainer {
  int taskContainerID;
  String name;
  DateTime created;
  String teamId;
  List<Task> taskList;
  int order;

  TaskContainer(
      {this.name, this.teamId, this.taskContainerID, this.created, this.taskList, this.order});

  TaskContainer.fromJson(Map<String, dynamic> json) {
    taskContainerID = json['id'];
    name = json['name'];
    created = dateTimeFromServerToLocale(json['created']);
    teamId = json['team_id'];
    order = json['order'];
    taskList = json['task_list'].map<Task>((task) {
      return Task.fromJson(task);
    })?.toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.taskContainerID;
    data['name'] = this.name;
    data['task_list'] = this.taskList;
    data['team_id'] = this.teamId;
    data['order'] = this.order;
    data['created'] = this.created?.toUtc().toString();
    return data;
  }
}
