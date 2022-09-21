import 'package:newappc/globals/utils/date_utils.dart';

import 'event.dart';

class Meeting extends Event {
  int meetingID;
  String name;
  String info;
  DateTime created;
  DateTime start;
  String creatorID;
  DateTime stop;
  List<String> meetingUsersIds;
  String teamId;
  bool isPublic;

  Meeting(
      {this.meetingID,
      this.name,
      this.info,
      this.created,
      this.start,
      this.stop,
      this.meetingUsersIds,
      this.teamId,
      this.isPublic,
      this.creatorID});

  Meeting.fromJson(Map<String, dynamic> json) {
    meetingID = json['meeting_id'];
    name = json['name'];
    info = json['info'];
    start = dateTimeFromServerToLocale(json['start']);
    stop = json['stop'] == 'None' ? null : dateTimeFromServerToLocale(json['stop']);
    meetingUsersIds = json['meeting_users_ids'].cast<String>();
    isPublic = json['is_public'];
    creatorID = json['creator_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['meeting_id'] = this.meetingID;
    data['name'] = this.name;
    data['info'] = this.info;
    data['start'] = this.start?.toUtc().toString();
    data['stop'] = this.stop?.toUtc().toString();
    data['meeting_users_ids'] = this.meetingUsersIds;
    data['team_id'] = this.teamId;
    data['is_public'] = this.isPublic;
    data['creator_id'] = this.creatorID;
    return data;
  }
}
