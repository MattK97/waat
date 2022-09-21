import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/styles/paddings.dart';
import 'package:newappc/models/TaskContainer.dart';
import 'package:newappc/models/task.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/task_tab/containers/viewmodel/containers_providers.dart';
import 'package:newappc/views/task_tab/task_creator/task_creator.dart';
import 'package:newappc/views/task_tab/task_tab.dart';

import 'task_tile.dart';

class TaskContainerWidget extends ConsumerWidget {
  final TaskContainer taskContainer;
  bool shouldSwitchPage = true;

  TaskContainerWidget({this.taskContainer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksContainerN = ref.watch(tasksContainerNotifier);
    final taskContainerWidgets = ref.watch(taskContainerWidgetsProvider.state);

    final taskTabMainWidget = ref.watch(taskTabMainWidgetProvider.state);
    final carouselController = ref.watch(carouselControllerProvider);
    final cardCarouselIndicator = ref.watch(containerCarouselIndicatorProvider.state);

    return Padding(
        padding: EdgeInsets.all(0),
        child: Card(
          color: Colors.teal[50],
          margin: EdgeInsets.fromLTRB(8, 8, 8, 16),
          elevation: 5,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(taskContainer.name,
                    style: TextStyle(
                        color: Colors.teal[600], fontWeight: FontWeight.bold, fontSize: 22)),
              ),
              Divider(
                color: Colors.white,
              ),
              if (taskContainer.taskList == null || taskContainer.taskList.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 64),
                  child: Center(
                      child: Text(
                    AppLocalizations.of(context).there_are_no_tasks_in_this_container,
                    style: TextStyle(color: Colors.grey),
                  )),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: taskContainer.taskList.length,
                  itemBuilder: (context, index) {
                    final Task task = taskContainer.taskList[index];
                    final GlobalKey globalKey = new GlobalKey();
                    return LongPressDraggable<TaskTile>(
                      onDragUpdate: (dragUpdateDetails) {
                        if (shouldSwitchPage) {
                          if (dragUpdateDetails.globalPosition.dx > 400) {
                            carouselController.nextPage();
                            shouldSwitchPage = false;
                            Future.delayed(Duration(seconds: 1))
                                .then((value) => shouldSwitchPage = true);
                          } else if (dragUpdateDetails.globalPosition.dx < 20) {
                            carouselController.previousPage();
                            shouldSwitchPage = false;
                            Future.delayed(Duration(seconds: 1))
                                .then((value) => shouldSwitchPage = true);
                          }
                        }
                      },
                      onDragEnd: (draggableDetails) async {},
                      onDraggableCanceled: (a, d) async {
                        final oldTaskContainerId = task.taskContainerID;
                        final newTaskContainerId = taskContainerWidgets
                            .state[cardCarouselIndicator.state].taskContainer.taskContainerID;
                        if (oldTaskContainerId != newTaskContainerId) {
                          tasksContainerN.changeTaskContainer(
                              oldTaskContainerId, newTaskContainerId, task);
                        }
                      },
                      hapticFeedbackOnStart: true,
                      child: TaskTile(
                        task: task,
                        key: globalKey,
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: TaskTile(
                          task: task,
                          key: globalKey,
                        ),
                      ),
                      feedback: FeedbackWidget(
                        dragChildKey: globalKey,
                        child: TaskTile(
                          task: task,
                        ),
                      ),
                    );
                  },
                ),
              Spacer(),
              InkWell(
                onTap: () {
                  taskTabMainWidget.state = TaskCreator(
                    chosenTaskContainer: taskContainer,
                  );
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(top: BorderSide(color: Colors.white)),
                    ),
                    child: Padding(
                        padding: allSixteen, child: Center(child: Icon(CupertinoIcons.add)))),
              ),
              SizedBox(
                height: 16,
              )
            ],
          ),
        ));
  }
}
