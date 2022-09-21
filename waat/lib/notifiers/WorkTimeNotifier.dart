// import 'package:flutter/material.dart';
// import 'package:newappc/models/Team.dart';
// import 'package:newappc/models/WorkTime.dart';
// import 'package:newappc/services/UserApiRequests.dart';
//
// class WorkTimeNotifier extends ChangeNotifier {
//   WorkTimeNotifier({this.team});
//   final Team team;
//
//   List<WorkTime> workTimeList;
//
//   Future<void> fetchWorkTimeList(int month) async {
//     final results = await UserApiRequests().fetchWorkTime(team.teamId, DateTime.now().month);
//     workTimeList = results;
//     notifyListeners();
//   }
// }
