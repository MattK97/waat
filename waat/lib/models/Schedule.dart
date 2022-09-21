import 'package:newappc/globals/utils/date_utils.dart';
import 'package:newappc/models/ScheduleSwap.dart';

class Schedule {
  int id;
  DateTime start;
  DateTime stop;
  String userID;
  bool confirmation;
  String teamID;
  bool sickLeave;
  bool holiday;
  List<ScheduleSwap> scheduleSwaps;

  Schedule(
      {this.id,
      this.start,
      this.stop,
      this.userID,
      this.confirmation,
      this.teamID,
      this.sickLeave,
      this.holiday,
      this.scheduleSwaps});

  Schedule.fromJson(Map<String, dynamic> json) {
    id = json['schedule_id'];
    start = dateTimeFromServerToLocale(json['start']);
    stop = dateTimeFromServerToLocale(json['stop']);
    userID = json['user_id'];
    confirmation = json['confirmation'];
    holiday = json['holiday'];
    sickLeave = json['sickleave'];
    teamID = json['team_id'];
    scheduleSwaps = json['schedule_swaps'] == null
        ? []
        : json['schedule_swaps'].map<ScheduleSwap>((task) {
            return ScheduleSwap.fromJson(task);
          })?.toList();
    ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schedule_id'] = this.id;
    data['start'] = this.start?.toUtc().toString();
    data['stop'] = this.stop?.toUtc().toString();
    data['user_id'] = this.userID;
    data['confirmation'] = this.confirmation;
    data['holiday'] = this.holiday;
    data['sickleave'] = this.sickLeave;
    data['team_id'] = this.teamID;
    data['schedule_swaps'] = this.scheduleSwaps;
    return data;
  }
}
