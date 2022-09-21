import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/widgets/custom_section_title.dart';
import 'package:newappc/globals/widgets/custom_titled_container.dart';
import 'package:newappc/rest/response/response_status.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/settings_tab/team_settings/viewmodel/team_settings_viewmodel.dart';

final teamSettingsViewModel = ChangeNotifierProvider.autoDispose<TeamSettingsViewModel>((ref) {
  return TeamSettingsViewModel(ref: ref.read);
});

class TeamSettings extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Colors.teal[400],
            leading: IconButton(
              icon: Icon(CupertinoIcons.chevron_left),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
            ),
            title: Text(
              AppLocalizations.of(context).team.toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: ListView(
          children: [ModeratorList(), RegularList(), DeleteGroup()],
        ),
      ),
    );
  }
}

final nameMatchProvider = StateProvider.autoDispose<bool>((ref) => false);
final textController = StateProvider.autoDispose((ref) => TextEditingController());

class DeleteAlertDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameMatch = ref.watch(nameMatchProvider.state);
    final chosenTeam = ref.watch(chosenTeamProvider.state).state;
    final controller = ref.watch(textController.state);
    return AlertDialog(
      title: Text("Team removing"),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(AppLocalizations.of(context).are_you_sure_delete_team),
            SizedBox(
              height: 8,
            ),
            TextField(
              decoration: InputDecoration(
                icon: Icon(
                  CupertinoIcons.trash,
                  color: Colors.red,
                ),
                hintText: AppLocalizations.of(context).team,
              ),
              controller: controller.state,
              onChanged: (value) {
                if (value == chosenTeam.name) {
                  nameMatch.state = true;
                } else {
                  nameMatch.state = false;
                }
              },
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            AppLocalizations.of(context).delete_group,
            style: TextStyle(color: nameMatch.state ? Colors.red : Colors.grey),
          ),
          onPressed: nameMatch.state
              ? () async {
                  if (await teamServices
                      .deleteTeam(chosenTeam.teamId)
                      .then((value) => value.code == ResponseStatus.valid)) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
                }
              : null,
        ),
        TextButton(
          child: Text(
            AppLocalizations.of(context).cancel,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class DeleteGroup extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return DeleteAlertDialog();
        },
      );
    }

    return Card(
      child: ListTile(
        onTap: _showMyDialog,
        leading: Icon(
          CupertinoIcons.trash,
          color: Colors.red,
        ),
        title: Text(AppLocalizations.of(context).delete_group),
      ),
    );
  }
}

class ModeratorList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamSettingsN = ref.watch(teamSettingsViewModel);
    final chosenTeam = ref.watch(chosenTeamProvider.state).state;

    return CustomTitledContainer(
      customSectionTitle: CustomSectionTitle(
        leftIcon: CupertinoIcons.person_2_square_stack,
        rightIcon: CupertinoIcons.add,
        disableRightIcon: false,
        color: Colors.teal[400],
        title: AppLocalizations.of(context).moderators,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return UserListDialog();
              });
        },
      ),
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount:
              ref.watch(usersNotifier).userList.where((element) => element.isModerator).length,
          itemBuilder: (context, index) {
            final user = ref
                .watch(usersNotifier)
                .userList
                .where((element) => element.isModerator)
                .toList()[index];
            return Dismissible(
                direction: DismissDirection.endToStart,
                key: UniqueKey(),
                background: Container(
                  color: Colors.red,
                  child: Icon(
                    CupertinoIcons.trash,
                    color: Colors.white,
                  ),
                ),
                confirmDismiss: (DismissDirection direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(AppLocalizations.of(context).confirm),
                        content: Text('Are you sure that you want to degrade this user'),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(
                                'Degrade',
                              )),
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(AppLocalizations.of(context).cancel,
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) async {
                  if (await teamSettingsN.degradeUser(chosenTeam.teamId, user.userID)) {
                  } else {}
                },
                child: ListTile(
                  leading: Icon(CupertinoIcons.person),
                  title: Text("${user.firstName} ${user.lastName}"),
                ));
          }),
    );
  }
}

class RegularList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chosenTeam = ref.watch(chosenTeamProvider.state).state;
    final teamSettingsN = ref.watch(teamSettingsViewModel);

    return CustomTitledContainer(
      customSectionTitle: CustomSectionTitle(
        leftIcon: CupertinoIcons.person_2_square_stack,
        rightIcon: CupertinoIcons.add,
        disableRightIcon: true,
        color: Colors.teal[400],
        title: AppLocalizations.of(context).members,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return UserListDialog();
              });
        },
      ),
      child: ref.watch(usersNotifier).userList.where((element) => !element.isModerator).isEmpty
          ? Center(
              child: Column(
              children: [
                Text(AppLocalizations.of(context).members),
                SizedBox(
                  height: 10,
                ),
                RichText(text: TextSpan(text: "🖕🏻 ", style: TextStyle(fontSize: 30)))
              ],
            ))
          : ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:
                  ref.watch(usersNotifier).userList.where((element) => !element.isModerator).length,
              itemBuilder: (context, index) {
                final user = ref
                    .watch(usersNotifier)
                    .userList
                    .where((element) => !element.isModerator)
                    .toList()[index];
                return Dismissible(
                    direction: DismissDirection.endToStart,
                    key: UniqueKey(),
                    background: Container(
                      color: Colors.red,
                      child: Icon(
                        CupertinoIcons.trash,
                        color: Colors.white,
                      ),
                    ),
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context).confirm),
                            content: Text('Are you sure team member'),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: Text(
                                    AppLocalizations.of(context).delete.toUpperCase(),
                                  )),
                              FlatButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text(AppLocalizations.of(context).cancel,
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) async {
                      if (await teamSettingsN.degradeUser(chosenTeam.teamId, user.userID)) {
                      } else {}
                    },
                    child: ListTile(
                      leading: Icon(CupertinoIcons.person),
                      title: Text("${user.firstName} ${user.lastName}"),
                    ));
              }),
    );
  }
}

class UserListDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamSettingsN = ref.watch(teamSettingsViewModel);
    final users =
        ref.watch(usersNotifier).userList.where((element) => !element.isModerator).toList();
    final chosenTeam = ref.watch(chosenTeamProvider.state).state;
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
            Text(AppLocalizations.of(context).chose_team_member),
            SizedBox(
              height: 15,
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    onTap: () async {
                      if (await teamSettingsN.promoteUser(chosenTeam.teamId, user.userID)) {
                      } else {}
                    },
                    leading: Icon(Icons.person),
                    title: Text("${user.firstName} ${user.lastName}"),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
