import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/widgets/custom_action_button.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/task_tab/containers/task_container_widget.dart';
import 'package:newappc/views/task_tab/task_container_creator/viewmodel/task_container_creator_providers.dart';

class TaskContainerCreatorDialog extends StatefulWidget {
  final TaskContainerWidget chosenTaskContainerWidget;

  TaskContainerCreatorDialog({this.chosenTaskContainerWidget});

  @override
  _TaskContainerCreatorDialogState createState() => _TaskContainerCreatorDialogState();
}

class _TaskContainerCreatorDialogState extends State<TaskContainerCreatorDialog> {
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.chosenTaskContainerWidget != null) {
      nameController.text = widget.chosenTaskContainerWidget.taskContainer.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final taskContainerCreatorVM = ref.watch(taskContainerCreatorViewModelProvider);
      final taskContainerN = ref.watch(tasksContainerNotifier);
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 15,
              ),
              widget.chosenTaskContainerWidget == null
                  ? Text(AppLocalizations.of(context).create_new_task_container)
                  : Text(AppLocalizations.of(context).update_task_container),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 32),
                child: TextFormField(
                  maxLines: null,
                  autofocus: false,
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: AppLocalizations.of(context).name,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  ),
                ),
              ),
              CustomActionButton(
                onPressed: () {
                  taskContainerCreatorVM.operateOnTaskContainer(
                      chosenTaskContainer: widget.chosenTaskContainerWidget == null
                          ? null
                          : widget.chosenTaskContainerWidget.taskContainer,
                      name: nameController.text,
                      order: taskContainerN.taskContainerList.isEmpty
                          ? 1
                          : taskContainerN.taskContainerList
                                  .map((e) => e.order)
                                  .toList()
                                  .reduce((curr, next) => curr > next ? curr : next) +
                              1);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
