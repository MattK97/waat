import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/widgets/custom_section_title.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/settings_tab/account_settings/update_color_screen.dart';
import 'package:newappc/views/settings_tab/account_settings/update_name_screen.dart';

import '../../../additional_widgets/hex_color.dart';
import '../../../globals/widgets/custom_titled_container.dart';

class AccountDetails extends ConsumerWidget {
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

    final authVM = ref.watch(authServiceViewModel);
    final user = ref
        .watch(usersNotifier)
        .userList
        .firstWhere((element) => element.userID == authVM.user.uid);

    return CustomTitledContainer(
      customSectionTitle: CustomSectionTitle(
        leftIcon: CupertinoIcons.settings,
        rightIcon: CupertinoIcons.add,
        disableRightIcon: true,
        color: Colors.teal[400],
        title: AppLocalizations.of(context).account_settings,
      ),
      child: Column(
        children: [
          ListTile(
            dense: true,
            title: Text("Email"), //TODO ADD LOCALIZATION
            subtitle: Text(authVM.user?.email),
            trailing: Icon(CupertinoIcons.right_chevron),
          ),
          const SizedBox(
            height: 25,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => UpdateName(
                        typeEnum: TypeEnum.name,
                      )));
            },
            dense: true,
            title: Text(AppLocalizations.of(context).first_name),
            subtitle: Text(user?.firstName),
            trailing: Icon(CupertinoIcons.right_chevron),
          ),
          const SizedBox(
            height: 25,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => UpdateName(typeEnum: TypeEnum.lastName)));
            },
            dense: true,
            title: Text(AppLocalizations.of(context).last_name),
            subtitle: Text(user?.lastName),
            trailing: Icon(CupertinoIcons.right_chevron),
          ),
          const SizedBox(
            height: 25,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => UpdateColor()));
            },
            dense: true,
            title: Text(
              AppLocalizations.of(context).color,
              style: TextStyle(color: HexColor(user.color)),
            ),
            trailing: Icon(CupertinoIcons.right_chevron, color: HexColor(user.color)),
          ),
          const SizedBox(
            height: 25,
          ),
          ListTile(
            onTap: () {
              _showMyDialog();
            },
            dense: true,
            title: Text(
              AppLocalizations.of(context).delete_account,
              style: TextStyle(color: Colors.red),
            ),
            trailing: Icon(CupertinoIcons.trash, color: Colors.red),
          ),
        ],
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
    final authVM = ref.watch(authServiceViewModel);
    final controller = ref.watch(textController.state);
    return AlertDialog(
      title: Text(AppLocalizations.of(context).are_you_sure_delete_account),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(AppLocalizations.of(context).are_you_sure_delete_account),
            const SizedBox(
              height: 8,
            ),
            TextField(
              decoration: InputDecoration(
                icon: const Icon(
                  CupertinoIcons.trash,
                  color: Colors.red,
                ),
                hintText: 'Email',
              ),
              controller: controller.state,
              onChanged: (value) {
                if (value == authVM.user.email) {
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
            AppLocalizations.of(context).delete,
            style: TextStyle(color: nameMatch.state ? Colors.red : Colors.grey),
          ),
          onPressed: nameMatch.state
              ? () async {
                  await authVM.deleteAccount();
                }
              : null,
        ),
        TextButton(
          child: Text(AppLocalizations.of(context).cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
