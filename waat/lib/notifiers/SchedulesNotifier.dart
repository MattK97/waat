import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newappc/models/Schedule.dart';
import 'package:newappc/models/ScheduleSwap.dart';
import 'package:newappc/models/ScheduleSwapHistory.dart';
import 'package:newappc/models/Team.dart';
import 'package:newappc/rest/response/response_status.dart';
import 'package:newappc/screens/MainScreen.dart';

class SchedulesNotifier extends ChangeNotifier {
  SchedulesNotifier(this.team);

  List<Schedule> scheduleList;
  List<ScheduleSwapHistory> scheduleSwapHistoryList;
  Team team;

  Future<void> fetchSchedule(int month, int year) async {
    final results =
        await scheduleServices.fetchSchedules(team.teamId, month, year).then((value) => value.data);
    scheduleList = results;
    notifyListeners();
  }

  Future<bool> operateOnSchedules(List<Schedule> scheduleList) async {
    List<Schedule> schedulesToCreate = scheduleList.where((element) => element.id == null).toList();
    List<Schedule> schedulesToUpdate = scheduleList.where((element) => element.id != null).toList();
    schedulesToCreate.forEach((element) async {
      await createSchedule(element);
    });
    schedulesToUpdate.forEach((element) async {
      await updateSchedule(element);
    });
    return true;
  }

  Future<bool> createSchedule(Schedule schedule) async {
    int result = await scheduleServices
        .createSchedule(team.teamId, schedule)
        .then((value) => value.data['object_id']);
    ;
    if (result != null) {
      schedule.id = result;
      this.scheduleList.add(schedule);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updateSchedule(Schedule schedule) async {
    bool result = await scheduleServices
        .updateSchedule(team.teamId, schedule)
        .then((value) => value.code == ResponseStatus.valid);
    ;
    if (result) {
      this.scheduleList.removeWhere((oldSchedule) => oldSchedule.id == schedule.id);
      this.scheduleList.add(schedule);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> confirmSchedules(Schedule schedule) async {
    return updateSchedule(schedule);
  }

  Future<bool> removeSchedule(Schedule schedule) async {
    final result = await scheduleServices
        .deleteSchedule(team.teamId, schedule.id)
        .then((value) => value.code == ResponseStatus.valid);
    ;
    if (result) {
      this.scheduleList.removeWhere((element) => element.id == schedule.id);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> createScheduleSwap(ScheduleSwap scheduleSwap) async {
    int scheduleSwapId = await scheduleServices
        .createScheduleSwap(team.teamId, scheduleSwap)
        .then((value) => value.data['object_id']);
    ;
    if (scheduleSwapId != null) {
      scheduleSwap.id = scheduleSwapId;
      this
          .scheduleList
          .firstWhere((element) => element.id == scheduleSwap.firstScheduleId)
          .scheduleSwaps
          .add(scheduleSwap);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> removeScheduleSwap(ScheduleSwap scheduleSwap) async {
    final result = await scheduleServices
        .deleteSchedule(team.teamId, scheduleSwap.id)
        .then((value) => value.code == ResponseStatus.valid);
    ;
    if (result) {
      this.scheduleList.removeWhere((element) => element.id == scheduleSwap.id);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updateScheduleSwap(ScheduleSwap scheduleSwap) async {
    final result = await scheduleServices
        .updateScheduleSwap(team.teamId, scheduleSwap.id, scheduleSwap.agreement)
        .then((value) => value.code == ResponseStatus.valid);
    ;
    notifyListeners();
    if (result) {
      return true;
    }
    return false;
  }

  Future<void> fetchScheduleSwapHistory(int month) async {
    final results = await scheduleServices
        .fetchScheduleSwapHistory(team.teamId, month)
        .then((value) => value.data);
    scheduleSwapHistoryList = results;
    notifyListeners();
  }
}
