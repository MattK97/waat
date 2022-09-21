import 'package:newappc/globals/utils/date_utils.dart';

class ScheduleSwap {
  int id;
  DateTime created;
  int firstScheduleId;
  int secondScheduleId;
  bool agreement;
  String requesterId;

  ScheduleSwap(
      {this.id,
      this.created,
      this.firstScheduleId,
      this.secondScheduleId,
      this.agreement,
      this.requesterId});

  ScheduleSwap.fromJson(Map<String, dynamic> json) {
    id = json['schedule_swap_id'];
    created = dateTimeFromServerToLocale(json['created']);
    firstScheduleId = json['first_schedule_id'];
    secondScheduleId = json['second_schedule_id'];
    agreement = json['agreement'];
    requesterId = json['requester_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schedule_swap_id'] = this.id;
    data['created'] = this.created?.toUtc().toString();
    data['first_schedule_id'] = this.firstScheduleId;
    data['second_schedule_id'] = this.secondScheduleId;
    data['agreement'] = this.agreement;
    return data;
  }
}
