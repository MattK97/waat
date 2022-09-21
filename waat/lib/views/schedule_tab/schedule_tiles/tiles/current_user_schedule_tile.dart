import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/chosen_user_card.dart';
import 'package:newappc/views/schedule_tab/schedule_tiles/tiles/schedule_tile.dart';

import '../../../../main.dart';

class CurrentUserScheduleTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authVM = ref.watch(authServiceViewModel);
    final user = ref
        .watch(usersNotifier)
        .userList
        ?.firstWhere((element) => element.userID == authVM.user.uid, orElse: () => null);

    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChosenUserCard(
                      user: user,
                    )),
          );
        },
        child: ScheduleTile(user));
  }
}
