import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/main.dart';
import 'package:newappc/screens/MainScreen.dart';

class UpdateInfo extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pushN = ref.watch(pushNotificationProvider);
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      switchInCurve: Curves.easeInOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          child: child,
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(animation),
        );
      },
      child: pushN.shouldUpdate ? UpdateInfoCard() : Container(),
    );
  }
}

class UpdateInfoCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pushNotificationServiceN = ref.watch(pushNotificationProvider);
    return InkWell(
      onTap: () {
        if (pushNotificationServiceN.newMeetings)
          ref.read(meetingNotifier).fetchMeetingList(DateTime.now().month);
        if (pushNotificationServiceN.newTasks)
          ref.read(tasksContainerNotifier).fetchTaskContainerList();
        if (pushNotificationServiceN.newAnnouncements)
          ref.read(announcementsNotifier).fetchAnnouncements(DateTime.now().month);
        if (pushNotificationServiceN.newSchedules)
          ref.read(schedulesNotifier).fetchSchedule(DateTime.now().month, DateTime.now().year);
        ref.read(schedulesNotifier).fetchScheduleSwapHistory(DateTime.now().month);
        // if (pushNotificationServiceN.newWorkTimes)
        //   context.read(workTimeNotifier).fetchWorkTimeList(DateTime.now().month);

        ref.read(usersNotifier).fetchTeamUserList();

        pushNotificationServiceN.shouldUpdate = false;
        pushNotificationServiceN.newMeetings = false;
        pushNotificationServiceN.newTasks = false;
        pushNotificationServiceN.newAnnouncements = false;
        pushNotificationServiceN.newSchedules = false;
        pushNotificationServiceN.newWorkTimes = false;
      },
      child: Card(
          color: Colors.blue[300],
          elevation: 32,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Update available',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
