import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:newappc/globals/widgets/custom_display_dialog.dart';
import 'package:newappc/models/task.dart';
import 'package:newappc/views/news_tab/calendar/chosen_day_widgets/custom_tile.dart';

class MonthlyTasks extends StatelessWidget {
  final List<Task> monthlyTaskList;
  MonthlyTasks({this.monthlyTaskList});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          Container(
              child: Text(
            AppLocalizations.of(context).tasks.toUpperCase(),
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          )),
          monthlyTaskList.isNotEmpty
              ? TaskList(
                  monthlyTaskList: monthlyTaskList,
                )
              : CustomTile(
                  title: '-',
                  tileType: TileType.task,
                )
        ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final List<Task> monthlyTaskList;
  TaskList({this.monthlyTaskList});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: monthlyTaskList.length,
        itemBuilder: (context, index) {
          final task = monthlyTaskList[index];
          return CustomTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => CustomDisplayDialog(
                        event: task,
                        color: Colors.teal[600],
                        isCreator: false,
                        userList: [],
                      ));
            },
            title: task.name,
            tileType: TileType.task,
          );
        });
  }
}
