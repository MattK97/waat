import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/widgets/custom_creator_base.dart';
import 'package:newappc/globals/widgets/custom_delete_dialog.dart';
import 'package:newappc/globals/widgets/custom_section_title.dart';
import 'package:newappc/models/TaskContainer.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/task_tab/containers/viewmodel/containers_providers.dart';
import 'package:newappc/views/task_tab/task_container_creator/task_container_creator_dialog.dart';
import 'package:newappc/views/task_tab/task_tab.dart';

class TaskContainerCreator extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskTabMainWidget = ref.watch(taskTabMainWidgetProvider.state);
    final tasksContainerN = ref.watch(tasksContainerNotifier);
    final taskContainerWidgets = ref.watch(taskContainerWidgetsProvider.state);
    return CustomCreatorBase(
      title: CustomSectionTitle(
        disableRightIcon: false,
        color: Colors.teal[400],
        leftIcon: CupertinoIcons.tag_fill,
        rightIcon: CupertinoIcons.clear,
        title: AppLocalizations.of(context).task_container_creator,
        onPressed: () {
          taskTabMainWidget.state = TasksTab();
        },
      ),
      children: [
        ReorderableListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: taskContainerWidgets.state.length,
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final item = taskContainerWidgets.state.removeAt(oldIndex);
            taskContainerWidgets.state.insert(newIndex, item);

            List<TaskContainer> orderedTaskContainerList = [];

            taskContainerWidgets.state.forEach((taskContainerWidget) {
              orderedTaskContainerList.add(taskContainerWidget.taskContainer);
            });
            tasksContainerN.updateTaskContainerOrder(orderedTaskContainerList);
          },
          itemBuilder: (context, index) {
            final taskContainer = taskContainerWidgets.state[index];
            return ListTile(
              key: Key('$index'),
              leading: Icon(Icons.reorder),
              title: Text(
                taskContainer.taskContainer.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(CupertinoIcons.pen),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return TaskContainerCreatorDialog(
                                chosenTaskContainerWidget: taskContainer);
                          });
                    },
                  ),
                  IconButton(
                    icon: Icon(CupertinoIcons.trash),
                    onPressed: () async {
                      bool decision = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDeleteDialog(
                              content:
                                  AppLocalizations.of(context).are_you_sure_delete_task_container);
                        },
                      );
                      if (decision) {
                        tasksContainerN.removeTaskContainer(taskContainer.taskContainer);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
        Divider(),
        GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return TaskContainerCreatorDialog();
                  });
            },
            child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: 42,
                child: Icon(CupertinoIcons.add))),
        Divider(),
      ],
    );
  }
}
