import 'package:newappc/globals/utils/date_utils.dart';
import 'package:newappc/globals/widgets/custom_date_range_picker.dart';

import 'event.dart';

class Task extends Event {
  int taskID;
  String name;
  String creatorID;
  String info;
  DateTime start;
  DateTime stop;
  List<String> taskUsersIds;
  String teamId;
  CustomDateRangePicker dateRange;
  int taskContainerID;
  bool isPublic;
  int order;

  Task(
      {this.taskID,
      this.name,
      this.info,
      this.start,
      this.stop,
      this.taskUsersIds,
      this.teamId,
      this.order,
      this.dateRange,
      this.taskContainerID,
      this.isPublic,
      this.creatorID});

  Task.fromJson(Map<String, dynamic> json) {
    taskID = json['task_id'];
    name = json['name'];
    info = json['info'];
    creatorID = json['creator_id'];
    order = json['order'];
    start = dateTimeFromServerToLocale(json['start']);
    stop = json['stop'] == 'None' ? null : dateTimeFromServerToLocale(json['stop']);
    taskUsersIds = json['task_users_ids'].cast<String>();
    taskContainerID = json['task_container_id'];
    isPublic = json['is_public'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task_id'] = this.taskID;
    data['name'] = this.name;
    data['info'] = this.info;
    data['start'] = this.start?.toUtc().toString();
    data['stop'] = this.stop?.toUtc().toString();
    data['task_users_ids'] = this.taskUsersIds;
    data['team_id'] = this.teamId;
    data['order'] = this.order;
    data['task_container_id'] = this.taskContainerID;
    data['is_public'] = this.isPublic;
    data['creator_id'] = this.creatorID;
    return data;
  }
}
