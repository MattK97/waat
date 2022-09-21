import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/globals/styles/colors.dart';
import 'package:newappc/globals/widgets/custom_display_dialog.dart';
import 'package:newappc/models/meeting.dart';
import 'package:newappc/views/news_tab/calendar/chosen_day_widgets/custom_tile.dart';

class MonthlyMeetings extends StatelessWidget {
  final List<Meeting> monthlyMeetingList;
  MonthlyMeetings({this.monthlyMeetingList});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          Container(
              child: Text(
            AppLocalizations.of(context).meetings.toUpperCase(),
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          )),
          monthlyMeetingList.isNotEmpty
              ? MeetingList(
                  monthlyMeetingList: monthlyMeetingList,
                )
              : CustomTile(
                  title: '-',
                  tileType: TileType.meeting,
                )
        ],
      ),
    );
  }
}

class MeetingList extends StatelessWidget {
  final List<Meeting> monthlyMeetingList;
  MeetingList({this.monthlyMeetingList});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: monthlyMeetingList.length,
        itemBuilder: (context, index) {
          Meeting meeting = monthlyMeetingList[index];
          return CustomTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => CustomDisplayDialog(
                        event: meeting,
                        color: primaryPurple,
                        created: Jiffy(meeting.created).yMMMd,
                        userList: [],
                        isCreator: false,
                      ));
            },
            title: Jiffy(meeting.start).Hm,
            tileType: TileType.meeting,
            startSubtitle: meeting.name,
          );
        });
  }
}
