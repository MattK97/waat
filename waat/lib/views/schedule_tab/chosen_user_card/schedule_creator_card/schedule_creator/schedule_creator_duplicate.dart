import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_creator_card/schedule_creator/user_list_dialog.dart';

class ScheduleCreatorDuplicate extends StatelessWidget {
  final User user;
  ScheduleCreatorDuplicate({this.user});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListTile(
        leading: Icon(
          CupertinoIcons.calendar_badge_plus,
          color: Colors.purple,
        ),
        title: Text(AppLocalizations.of(context).duplicate_schedule_for_whole_week),
        onTap: () {
          showDialog(context: context, builder: (context) => UserListDialog(user: user));
        },
      ),
    );
  }
}
