import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/additional_widgets/color_manipulator.dart';
import 'package:newappc/additional_widgets/hex_color.dart';
import 'package:newappc/models/Schedule.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_creator_card/specific_day_screen/new_schedule_tab.dart';

import 'new_schedule_swap_tab.dart';

class SpecificDayScreen extends ConsumerWidget {
  final DateTime dateTime;
  final User user;
  final Schedule schedule;

  SpecificDayScreen({this.user, this.schedule, this.dateTime});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isModerator = ref
        .watch(usersNotifier)
        .userList
        .firstWhere((element) => element.userID == ref.watch(authServiceViewModel).user.uid)
        .isModerator;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: ColorManipulator.lighten(HexColor(user.color)),
          iconTheme: IconThemeData(color: ColorManipulator.darken(HexColor(user.color))),
          bottom: TabBar(
            indicatorColor: ColorManipulator.darken(HexColor(user.color)),
            labelColor: ColorManipulator.darken(HexColor(user.color)),
            tabs: [
              Tab(
                text: AppLocalizations.of(context).create,
              ),
              Tab(text: AppLocalizations.of(context).swap),
            ],
          ),
          title: Text(
            Jiffy(dateTime).MMMEd.toUpperCase(),
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorManipulator.darken(HexColor(user.color))),
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: NewScheduleTab(
                  isModerator: isModerator,
                  user: user,
                  schedule: schedule,
                  dateTime: dateTime,
                )),
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: NewScheduleSwapTab(
                  dateTime: dateTime,
                  schedule: schedule,
                  user: user,
                )),
          ],
        ),
      ),
    );
  }
}
