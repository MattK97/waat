import 'package:newappc/globals/utils/date_utils.dart';

class WorkTime {
  int id;
  String userID;
  DateTime start;
  DateTime stop;
  String teamID;
  bool confirmation;
  WorkTime({this.start, this.stop, this.confirmation, this.userID});

  WorkTime.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userID = json['user_id'];
    start = dateTimeFromServerToLocale(json['start']);
    stop = json['stop'] == null ? null : dateTimeFromServerToLocale(json['stop']);
    confirmation = json['confirmation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start?.toUtc();
    data['stop'] = this.stop?.toUtc();
    return data;
  }
}
