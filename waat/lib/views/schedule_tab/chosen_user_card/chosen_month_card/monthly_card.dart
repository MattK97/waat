import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/widgets/custom_divider.dart';
import 'package:newappc/globals/widgets/custom_section_title.dart';
import 'package:newappc/globals/widgets/custom_titled_container.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/chosen_month_card/custom_month_picker.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/chosen_month_card/monthly_meetings.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/chosen_month_card/monthly_stats.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/chosen_month_card/monthly_tasks.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/chosen_month_card/viewmodel/chosen_month_card_providers.dart';

class MonthlyCard extends ConsumerWidget {
  final User user;
  MonthlyCard({this.user});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomTitledContainer(
      customSectionTitle: CustomSectionTitle(
        disableRightIcon: true,
        leftIcon: CupertinoIcons.chart_bar_square,
        color: Colors.teal[400],
        title: AppLocalizations.of(context).monthly_stats,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          CustomMonthPicker(),
          CustomDivider(),
          MonthlyStats(
            totalTimeBySchedule: ref.watch(chosenMonthCardViewModel).userScheduleTotalTime(user),
          ),
          CustomDivider(),
          SizedBox(
            height: 16,
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            child: Column(
              children: [
                MonthlyTasks(
                  monthlyTaskList: ref.watch(chosenMonthCardViewModel).userMonthlyTaskList(user),
                ),
                MonthlyMeetings(
                  monthlyMeetingList:
                      ref.watch(chosenMonthCardViewModel).userMonthlyMeetingList(user),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
