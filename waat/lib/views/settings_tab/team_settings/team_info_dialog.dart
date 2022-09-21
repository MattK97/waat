import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/widgets/custom_action_button.dart';
import 'package:newappc/screens/MainScreen.dart';

import 'team_settings_screen.dart';

class TeamInfoDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isModerator = ref.watch(isModeratorProvider.state).state;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                ref.watch(chosenTeamProvider.state).state.name.toUpperCase(),
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal[600]),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TeamEntryCode(),
            SizedBox(
              height: 15,
            ),
            isModerator
                ? CustomActionButton(
                    text: 'Settings', // TODO ADD LOCALIZATION
                    onPressed: () {
                      Navigator.of(context)
                          .push(CupertinoPageRoute(builder: (context) => TeamSettings()));
                    },
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

class TeamEntryCode extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chosenTeam = ref.watch(chosenTeamProvider.state).state;
    return Column(
      children: [
        Text('Team Entry Code'), //TODO ADD LOCALIZATION
        Text(
          chosenTeam.entryCode,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
