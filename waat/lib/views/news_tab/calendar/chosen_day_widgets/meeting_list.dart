import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/globals/styles/colors.dart';
import 'package:newappc/globals/widgets/custom_display_dialog.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/news_tab/calendar/viewmodel/calendar_providers.dart';
import 'package:newappc/views/news_tab/meeting_creator/meeting_creator.dart';

import '../../../../main.dart';
import '../../news_tab.dart';
import 'custom_tile.dart';

class MeetingList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDayVM = ref.watch(chosenDayViewModel);
    return Container(
      child: Column(
        children: [
          currentDayVM.selectedDayMeetingList.isEmpty
              ? CustomTile(
                  title: '-',
                  tileType: TileType.meeting,
                )
              : Meetings(),
        ],
      ),
    );
  }
}

class Meetings extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDayVM = ref.watch(chosenDayViewModel);
    final meetingsN = ref.watch(meetingNotifier);
    final newsTabMainWidget = ref.watch(newsTabMainWidgetProvider.state);
    final usersN = ref.watch(usersNotifier);
    final authVM = ref.watch(authServiceViewModel);
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: currentDayVM.selectedDayMeetingList.length,
        shrinkWrap: true,
        itemBuilder: (_, index) {
          final meeting = currentDayVM.selectedDayMeetingList[index];
          return CustomTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => CustomDisplayDialog(
                      event: meeting,
                      color: primaryPurple,
                      created: Jiffy(meeting.created).yMMMd,
                      userList: usersN.userList
                          .where((element) => meeting.meetingUsersIds.contains(element.userID))
                          .toList(),
                      isCreator: authVM.user.uid == meeting.creatorID,
                      onDelete: () => meetingsN.removeMeeting(meeting),
                      onEdit: () {
                        Navigator.pop(context);
                        newsTabMainWidget.state = MeetingCreator(
                          chosenMeeting: meeting,
                        );
                      }));
            },
            title: Jiffy(meeting.start).Hm,
            tileType: TileType.meeting,
            startSubtitle: meeting.name,
          );
        });
  }
}
