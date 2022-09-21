import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/widgets/custom_display_dialog.dart';
import 'package:newappc/models/task.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/task_tab/task_creator/task_creator.dart';

import '../../../main.dart';
import '../task_tab.dart';

class TaskTile extends ConsumerWidget {
  final Task task;
  final key;

  TaskTile({this.key, this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey key = GlobalKey();
    final taskTabMainWidget = ref.watch(taskTabMainWidgetProvider.state);
    final usersN = ref.watch(usersNotifier);
    final tasksContainersN = ref.watch(tasksContainerNotifier);
    final authVM = ref.watch(authServiceViewModel);

    return Card(
      color: Colors.teal[600],
      elevation: 2,
      child: ListTile(
          key: key,
          dense: true,
          title: Text(
            task.name,
            style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white),
          ),
          trailing: Icon(CupertinoIcons.chevron_right, color: Colors.white),
          subtitle: Text(task.info,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDisplayDialog(
                      event: task,
                      color: Colors.teal[600],
                      isCreator: authVM.user.uid == task.creatorID,
                      userList: usersN.userList
                          .where((element) => task.taskUsersIds.contains(element.userID))
                          .toList(),
                      onEdit: () {
                        Navigator.pop(context);
                        taskTabMainWidget.state = TaskCreator(
                          chosenTask: task,
                          chosenTaskContainer: tasksContainersN.taskContainerList.firstWhere(
                              (element) => element.taskContainerID == task.taskContainerID),
                        );
                      },
                      onDelete: () {
                        tasksContainersN.removeTask(task);
                      },
                    ));
          }),
    );
  }
}

class FeedbackWidget extends StatelessWidget {
  final GlobalKey dragChildKey;
  final Widget child;

  const FeedbackWidget({Key key, this.dragChildKey, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Determine the size of the original widget
    final RenderBox renderBoxRed = dragChildKey.currentContext.findRenderObject();
    final size = renderBoxRed.size;

    return Transform.rotate(
      angle: pi / 20.0,
      child: Container(
        width: size.width,
        height: size.height,
        child: Material(
          color: Colors.transparent,
          child: child,
        ),
      ),
    );
  }
}
