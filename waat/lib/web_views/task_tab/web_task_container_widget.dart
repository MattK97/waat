import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/styles/paddings.dart';
import 'package:newappc/models/TaskContainer.dart';
import 'package:newappc/models/task.dart';
import 'package:newappc/views/task_tab/task_creator/task_creator.dart';
import 'package:newappc/views/task_tab/task_tab.dart';
import 'package:newappc/web_views/task_tab/web_task_tile.dart';

class WebTaskContainerWidget extends ConsumerWidget {
  final TaskContainer taskContainer;
  bool shouldSwitchPage = true;

  WebTaskContainerWidget({this.taskContainer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskTabMainWidget = ref.watch(taskTabMainWidgetProvider.state);

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.2,
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
                  'There are no task in this group',
                  style: TextStyle(color: Colors.grey),
                )),
              )
            else
              Column(
                children: taskContainer.taskList.map((e) {
                  final Task task = e;
                  final GlobalKey globalKey = new GlobalKey();
                  return GestureDetector(
                    child: LongPressDraggable<WebTaskTile>(
                      onDragEnd: (draggableDetails) async {},
                      hapticFeedbackOnStart: true,
                      child: WebTaskTile(
                        task: task,
                        key: globalKey,
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: WebTaskTile(
                          task: task,
                          key: globalKey,
                        ),
                      ),
                      feedback: WebFeedbackWidget(
                        dragChildKey: globalKey,
                        child: WebTaskTile(
                          task: task,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
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
                  child:
                      Padding(padding: allSixteen, child: Center(child: Icon(CupertinoIcons.add)))),
            ),
            SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}
