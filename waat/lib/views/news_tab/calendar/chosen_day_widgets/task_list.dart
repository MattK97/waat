import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/widgets/custom_display_dialog.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/news_tab/calendar/chosen_day_widgets/custom_tile.dart';
import 'package:newappc/views/news_tab/calendar/viewmodel/calendar_providers.dart';

class TaskList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDayVM = ref.watch(chosenDayViewModel);
    return Container(
      child: Column(
        children: [
          currentDayVM.selectedDayTaskList.isEmpty
              ? CustomTile(
                  title: '-',
                  tileType: TileType.task,
                )
              : Tasks(),
        ],
      ),
    );
  }
}

class Tasks extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDayVM = ref.watch(chosenDayViewModel);
    final usersN = ref.watch(usersNotifier);
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: currentDayVM.selectedDayTaskList.length,
        shrinkWrap: true,
        itemBuilder: (_, index) {
          final task = currentDayVM.selectedDayTaskList[index];
          return CustomTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => CustomDisplayDialog(
                        event: task,
                        color: Colors.teal[600],
                        isCreator: false,
                        userList: usersN.userList
                            .where((element) => task.taskUsersIds.contains(element.userID))
                            .toList(),
                      ));
            },
            title: task.name,
            tileType: TileType.task,
          );
        });
  }
}
