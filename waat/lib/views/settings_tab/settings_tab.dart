import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/widgets/custom_action_button.dart';
import 'package:newappc/main.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/settings_tab/account_settings/account_details.dart';

import 'team_settings/team_list.dart';

final AutoDisposeStateProvider<Widget> settingsTabMainWidgetProvider =
    StateProvider.autoDispose((ref) => Settings());

class SettingsTabAnimatedSwitcher extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingMainWidget = ref.watch(settingsTabMainWidgetProvider.state);
    return AnimatedSwitcher(
      duration: Duration(seconds: 1),
      switchInCurve: Curves.bounceIn,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          child: child,
          position: Tween<Offset>(
            begin: Offset(0.0, 2.0),
            end: Offset.zero,
          ).animate(animation),
        );
      },
      child: settingMainWidget.state,
    );
  }
}

class Settings extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authVM = ref.watch(authServiceViewModel);
    final bottomNavigationBarIndex = ref.watch(bottomNavigationBarIndexProvider.state);
    return Center(
        child: ListView(
      children: [
        Container(
          margin: EdgeInsets.only(top: 32, bottom: 32),
          height: MediaQuery.of(context).size.height / 10,
          child: Image.asset('assets/images/waat_logo_400.png'),
        ),
        TeamList(),
        SizedBox(
          height: 16,
        ),
        AccountDetails(),
        CustomActionButton(
          text: AppLocalizations.of(context).logout,
          onPressed: () async {
            await userServices.deleteToken();
            authVM.signOut();
            bottomNavigationBarIndex.state = 0;
          },
        )
      ],
    ));
  }
}
