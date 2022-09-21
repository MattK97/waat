import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/views/task_tab/task_container_creator/task_container_creator.dart';

import '../task_tab.dart';

final draggedWidgetSizeProvider = StateProvider<Size>((_) => Size(0, 0));

class CreateNewContainerWidget extends ConsumerWidget {
  CreateNewContainerWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksTabAnimatedSwitcher = ref.watch(taskTabMainWidgetProvider.state);
    return Padding(
      padding: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          tasksTabAnimatedSwitcher.state = TaskContainerCreator();
        },
        child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.grey[400])),
            child: Center(
                child: Icon(
              CupertinoIcons.add,
              color: Colors.grey,
              size: 32,
            ))),
      ),
    );
  }
}
