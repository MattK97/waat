import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newappc/globals/styles/colors.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/models/meeting.dart';
import 'package:newappc/models/task.dart';

class CalendarMarker extends StatelessWidget {
  final List<dynamic> listOfItems;
  final User user;

  CalendarMarker({this.listOfItems, this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Builder(
            builder: (context) {
              if (listOfItems.any((dynamicElement) => dynamicElement.runtimeType == Task)) {
                List<Task> taskList = [];
                listOfItems
                    .where((taskOrMeeting) => taskOrMeeting.runtimeType == Task)
                    .forEach((task) {
                  taskList.add(task as Task);
                });
                return Icon(CupertinoIcons.tag_fill,
                    size: 12,
                    color: taskList.firstWhere(
                                (element) => element.taskUsersIds.contains(user.userID),
                                orElse: () => null) ==
                            null
                        ? Colors.grey
                        : primaryTeal);
              }
              return Container();
            },
          ),
          SizedBox(
            width: 4,
          ),
          Builder(
            builder: (context) {
              if (listOfItems.any((dynamicElement) => dynamicElement.runtimeType == Meeting)) {
                List<Meeting> meetingList = [];
                listOfItems
                    .where((taskOrMeeting) => taskOrMeeting.runtimeType == Meeting)
                    .forEach((meeting) {
                  meetingList.add(meeting as Meeting);
                });
                return Icon(CupertinoIcons.person_3_fill,
                    size: 12,
                    color: meetingList.firstWhere(
                                (element) => element.meetingUsersIds.contains(user.userID),
                                orElse: () => null) ==
                            null
                        ? Colors.grey
                        : primaryPurple);
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}
