import 'package:newappc/globals/utils/date_utils.dart';

class ScheduleSwapHistory {
  final DateTime firstScheduleStart;
  final DateTime firstScheduleStop;
  final DateTime secondScheduleStart;
  final DateTime secondScheduleStop;
  final String firstScheduleUserId;
  final String secondScheduleUserId;
  final bool agreement;

  ScheduleSwapHistory(
      {this.firstScheduleStart,
      this.firstScheduleStop,
      this.secondScheduleStart,
      this.secondScheduleStop,
      this.firstScheduleUserId,
      this.secondScheduleUserId,
      this.agreement});

  Map<String, dynamic> toMap() {
    return {
      'firstScheduleStart': this.firstScheduleStart?.toUtc(),
      'firstScheduleStop': this.firstScheduleStop?.toUtc(),
      'secondScheduleStart': this.secondScheduleStart?.toUtc(),
      'secondScheduleStop': this.secondScheduleStop?.toUtc(),
      'firstScheduleUserId': this.firstScheduleUserId,
      'secondScheduleUserId': this.secondScheduleUserId,
      'agreement': this.agreement,
    };
  }

  factory ScheduleSwapHistory.fromMap(Map<String, dynamic> map) {
    return ScheduleSwapHistory(
      firstScheduleStart: dateTimeFromServerToLocale(map['first_schedule_start']),
      firstScheduleStop: dateTimeFromServerToLocale(map['first_schedule_stop']),
      secondScheduleStart: dateTimeFromServerToLocale(map['second_schedule_start']),
      secondScheduleStop: dateTimeFromServerToLocale(map['second_schedule_stop']),
      firstScheduleUserId: map['first_schedule_user_id'] as String,
      secondScheduleUserId: map['second_schedule_user_id'] as String,
      agreement: map['agreement'] as bool,
    );
  }
}
