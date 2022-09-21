import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/additional_widgets/hex_color.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_creator_card/schedule_creator/viewmodel/schedule_creator_providers.dart';

class UserListDialog extends ConsumerWidget {
  final User user;

  UserListDialog({this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userListDialogVM = ref.watch(userListDialogViewModel);
    final scheduleN = ref.watch(schedulesNotifier);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 15,
            ),
            Text(AppLocalizations.of(context).choose_team_mate),
            SizedBox(
              height: 15,
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: ref
                    .watch(usersNotifier)
                    .userList
                    .where((element) => element.userID != user.userID)
                    .toList()
                    .length,
                itemBuilder: (context, index) {
                  User userToChoose = ref
                      .watch(usersNotifier)
                      .userList
                      .where((element) => element.userID != user.userID)
                      .toList()[index];
                  return ListTile(
                    onTap: () async {
                      final copiedScheduleList = userListDialogVM.generateCopiedSchedule(
                          chosenUserToDuplicateFrom: userToChoose, user: user);
                      if (await scheduleN.operateOnSchedules(copiedScheduleList)) {
                        Navigator.pop(context);
                      }
                    },
                    leading: Icon(
                      Icons.person,
                      color: HexColor(userToChoose.color),
                    ),
                    title: Text("${userToChoose.firstName} ${userToChoose.lastName}"),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
