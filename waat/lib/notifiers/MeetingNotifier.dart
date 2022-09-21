import 'package:flutter/cupertino.dart';
import 'package:newappc/models/Team.dart';
import 'package:newappc/models/meeting.dart';
import 'package:newappc/rest/response/response_status.dart';
import 'package:newappc/screens/MainScreen.dart';

class MeetingNotifier extends ChangeNotifier {
  MeetingNotifier(this.team);

  List<Meeting> meetingList;
  Team team;

  Future<void> fetchMeetingList(int month) async {
    final results = await meetingServices
        .fetchMeetings(team.teamId, DateTime.now().month)
        .then((value) => value.data);
    meetingList = results;
    notifyListeners();
  }

  Future<bool> addMeeting(Meeting meeting) async {
    if (meeting == null) return false;
    int meetingID = await meetingServices
        .createMeeting(team.teamId, meeting)
        .then((value) => value.data['object_id']);
    if (meetingID != null) {
      meeting.meetingID = meetingID;
      meetingList.add(meeting);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updateMeeting(Meeting meeting) async {
    bool meetingID = await meetingServices
        .updateMeeting(team.teamId, meeting)
        .then((value) => value.code == ResponseStatus.valid);
    if (meetingID != null) {
      meetingList.removeWhere((element) => element.meetingID == meeting.meetingID);
      meetingList.add(meeting);
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeMeeting(Meeting meeting) async {
    final result = await meetingServices
        .deleteMeeting(team.teamId, meeting)
        .then((value) => value.code == ResponseStatus.valid);
    ;
    if (result) {
      meetingList.remove(meeting);
      notifyListeners();
    }
  }
}
