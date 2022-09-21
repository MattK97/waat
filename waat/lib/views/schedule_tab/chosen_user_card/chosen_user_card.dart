import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/app_bar.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/chosen_month_card/monthly_card.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_creator_card/schedule_creator/schedule_creator_card.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_swap_card/schedule_request.dart';

class ChosenUserCard extends ConsumerWidget {
  final User user;

  ChosenUserCard({this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          user: user,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 32,
          ),
          MonthlyCard(
            user: user,
          ),
          const SizedBox(
            height: 32,
          ),
          ScheduleCreatorCard(
            user: user,
          ),
          const SizedBox(
            height: 25,
          ),
          ScheduleRequests(user: user),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
