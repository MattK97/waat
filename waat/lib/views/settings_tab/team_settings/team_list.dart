import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/widgets/custom_section_title.dart';
import 'package:newappc/globals/widgets/custom_titled_container.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/settings_tab/team_settings/team_info_dialog.dart';

class TeamList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomTitledContainer(
      customSectionTitle: CustomSectionTitle(
        leftIcon: CupertinoIcons.person_2_square_stack,
        rightIcon: CupertinoIcons.add,
        disableRightIcon: true,
        color: Colors.teal[400],
        title: AppLocalizations.of(context).team_list,
      ),
      child: Column(
        children: [
          CurrentTeam(),
          const SizedBox(height: 16),
          TeamListView(),
        ],
      ),
    );
  }
}

class CurrentTeam extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chosenTeam = ref.watch(chosenTeamProvider.state).state;
    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return TeamInfoDialog();
            });
      },
      dense: true,
      leading: Icon(
        CupertinoIcons.group,
        color: Colors.teal[600],
      ),
      title: Text(chosenTeam.name),
      subtitle: Text(AppLocalizations.of(context).click_for_more),
    );
  }
}

class TeamListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chosenTeam = ref.watch(chosenTeamProvider.state).state;
    final list = ref
        .watch(teamListProvider.state)
        .state
        .where((element) => element.teamId != chosenTeam.teamId)
        .toList();
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (_, index) {
          final team = list[index];
          return ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return TeamInfoDialog();
                  });
            },
            dense: true,
            leading: Icon(
              CupertinoIcons.group,
              color: Colors.grey[600],
            ),
            title: Text(team?.name),
            subtitle: Text(AppLocalizations.of(context).click_for_more),
          );
        });
  }
}
