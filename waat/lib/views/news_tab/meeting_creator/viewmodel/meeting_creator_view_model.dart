import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/main.dart';
import 'package:newappc/models/meeting.dart';
import 'package:newappc/models/user_checkbox_item.dart';
import 'package:newappc/screens/MainScreen.dart';

import '../../news_tab.dart';

class MeetingCreatorViewModel extends ChangeNotifier {
  MeetingCreatorViewModel({this.ref});

  Reader ref;

  DateTime dateTime(DateTime chosenDate, TimeOfDay chosenDayTime) => DateTime(
      chosenDate.year, chosenDate.month, chosenDate.day, chosenDayTime.hour, chosenDayTime.minute);

  void operateOnMeeting(
          {Meeting chosenMeeting,
          String title,
          String info,
          DateTime chosenDayDate,
          TimeOfDay chosenDayTime,
          List<UserCheckboxItem> chosenUsers}) =>
      chosenMeeting == null
          ? _createNewMeeting(
              title: title,
              info: info,
              chosenDayDate: chosenDayDate,
              chosenDayTime: chosenDayTime,
              chosenUsers: chosenUsers)
          : _updateMeeting(
              chosenMeeting: chosenMeeting,
              title: title,
              info: info,
              chosenDayDate: chosenDayDate,
              chosenDayTime: chosenDayTime,
              chosenUsers: chosenUsers);

  Future<void> _createNewMeeting(
      {String title,
      String info,
      DateTime chosenDayDate,
      TimeOfDay chosenDayTime,
      List<UserCheckboxItem> chosenUsers}) async {
    Meeting meeting = Meeting(
        creatorID: ref(authServiceViewModel).user.uid,
        meetingID: null,
        start: dateTime(chosenDayDate, chosenDayTime),
        stop: dateTime(chosenDayDate, chosenDayTime),
        name: title,
        info: info,
        meetingUsersIds: chosenUsers
            .where((element) => element.isSelected)
            .map<String>((e) => e.user.userID)
            .toList(),
        teamId: ref(chosenTeamProvider.state).state.teamId,
        isPublic: true);
    if (await ref(meetingNotifier).addMeeting(meeting)) {
      ref(newsTabMainWidgetProvider.state).state = NewsTab();
    }
  }

  void _updateMeeting(
      {Meeting chosenMeeting,
      String title,
      String info,
      DateTime chosenDayDate,
      TimeOfDay chosenDayTime,
      List<UserCheckboxItem> chosenUsers}) async {
    Meeting meeting = Meeting(
        meetingID: chosenMeeting.meetingID,
        start: dateTime(chosenDayDate, chosenDayTime),
        stop: dateTime(chosenDayDate, chosenDayTime),
        name: title,
        info: info,
        meetingUsersIds: chosenUsers
            .where((element) => element.isSelected)
            .map<String>((e) => e.user.userID)
            .toList(),
        teamId: chosenMeeting.teamId,
        isPublic: chosenMeeting.isPublic);
    if (await ref(meetingNotifier).updateMeeting(meeting)) {
      ref(newsTabMainWidgetProvider.state).state = NewsTab();
    }
  }
}
