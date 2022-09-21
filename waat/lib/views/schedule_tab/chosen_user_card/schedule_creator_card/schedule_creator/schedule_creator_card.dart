import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/widgets/custom_divider.dart';
import 'package:newappc/globals/widgets/custom_section_title.dart';
import 'package:newappc/globals/widgets/custom_titled_container.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_creator_card/schedule_creator/schedule_creator.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_creator_card/schedule_creator/schedule_creator_duplicate.dart';

import 'week_picker/week_picker.dart';

class ScheduleCreatorCard extends ConsumerWidget {
  final User user;

  ScheduleCreatorCard({this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomTitledContainer(
      customSectionTitle: CustomSectionTitle(
        disableRightIcon: true,
        leftIcon: CupertinoIcons.time,
        color: Colors.teal[400],
        title: AppLocalizations.of(context).schedule_creator,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 32),
        child: Column(
          children: [
            WeekPicker(),
            CustomDivider(),
            ScheduleCreator(user: user),
            ScheduleCreatorDuplicate(user: user)
          ],
        ),
      ),
    );
  }
}
