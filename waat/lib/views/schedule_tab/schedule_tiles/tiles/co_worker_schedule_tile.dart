import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/chosen_user_card.dart';
import 'package:newappc/views/schedule_tab/schedule_tiles/tiles/schedule_tile.dart';

import '../../../../main.dart';

class CoWorkersScheduleTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authVM = ref.watch(authServiceViewModel);
    final isModerator = ref.watch(isModeratorProvider.state);
    final usersN = ref.watch(usersNotifier);
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount:
            usersN.userList.where((element) => element.userID != authVM.user.uid).toList().length,
        itemBuilder: (context, index) {
          final user =
              usersN.userList.where((element) => element.userID != authVM.user.uid).toList()[index];
          return GestureDetector(
              onTap: () {
                if (isModerator.state) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChosenUserCard(
                              user: user,
                            )),
                  );
                }
              },
              child: ScheduleTile(user));
        });
  }
}
