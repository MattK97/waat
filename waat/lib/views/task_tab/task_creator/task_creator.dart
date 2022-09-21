import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/widgets/custom_creator_base.dart';
import 'package:newappc/globals/widgets/custom_input_field.dart';
import 'package:newappc/globals/widgets/custom_section_title.dart';
import 'package:newappc/globals/widgets/custom_user_checkbox_list.dart';
import 'package:newappc/models/TaskContainer.dart';
import 'package:newappc/models/task.dart';
import 'package:newappc/models/user_checkbox_item.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/task_tab/task_creator/viewmodel/task_creator_providers.dart';
import 'package:newappc/views/task_tab/task_tab.dart';

import '../../../globals/widgets/custom_date_range_picker.dart';

class TaskCreator extends ConsumerStatefulWidget {
  final Task chosenTask;
  final TaskContainer chosenTaskContainer;

  TaskCreator({this.chosenTask, this.chosenTaskContainer});

  @override
  _TaskCreatorState createState() => _TaskCreatorState();
}

class _TaskCreatorState extends ConsumerState<TaskCreator> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _infoController = TextEditingController();
  List<UserCheckboxItem> _userCheckboxItemList;
  DateTimeRange _dateTimeRange;
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    if (widget.chosenTask != null) {
      _dateTimeRange = DateTimeRange(start: widget.chosenTask.start, end: widget.chosenTask.stop);
      _titleController.text = widget.chosenTask.name;
      _infoController.text = widget.chosenTask.info;
      _userCheckboxItemList = ref
          .read(usersNotifier)
          .userList
          .map((e) => UserCheckboxItem(e, widget.chosenTask.taskUsersIds.contains(e.userID)))
          .toList();
      _updateButton('');
    } else {
      _userCheckboxItemList =
          ref.read(usersNotifier).userList.map((e) => UserCheckboxItem(e, false)).toList();
    }
  }

  void _refreshDateTimeRangePicker(DateTimeRange pickedDateTimeRange) {
    setState(() {
      _dateTimeRange = pickedDateTimeRange;
    });
    _updateButton('');
  }

  void _updateUserCheckboxList(List<UserCheckboxItem> userCheckBoxList) {
    _userCheckboxItemList = userCheckBoxList;
    _updateButton('');
  }

  void _updateButton(String value) {
    setState(() {
      _isButtonDisabled = _dateTimeRange == null || _titleController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, WidgetRef ref, Widget child) {
      final taskCreatorVM = ref.watch(taskCreatorViewModel);
      final taskTabMainWidget = ref.watch(taskTabMainWidgetProvider.state);
      return CustomCreatorBase(
          isButtonDisabled: _isButtonDisabled,
          title: CustomSectionTitle(
            disableRightIcon: false,
            color: Colors.teal[400],
            leftIcon: CupertinoIcons.tag,
            rightIcon: CupertinoIcons.clear,
            title: AppLocalizations.of(context).task_creator,
            onPressed: () {
              taskTabMainWidget.state = TasksTab();
            },
          ),
          children: [
            CustomDateRangePicker(
              notifyParent: _refreshDateTimeRangePicker,
              pickedDateTimeRange: _dateTimeRange,
            ),
            CustomInputField(
              notifyParent: _updateButton,
              fieldName: AppLocalizations.of(context).title,
              textEditingController: _titleController,
            ),
            CustomInputField(
              fieldName: AppLocalizations.of(context).info,
              textEditingController: _infoController,
              expanded: true,
            ),
            CustomUserCheckboxList(
              userCheckboxItemList: _userCheckboxItemList,
              notifyParent: _updateUserCheckboxList,
            ),
          ],
          onSaveButtonPressed: () async {
            await taskCreatorVM.operateOnTask(
                chosenTask: widget.chosenTask,
                title: _titleController.text,
                info: _infoController.text,
                dateTimeRange: _dateTimeRange,
                taskContainer: widget.chosenTaskContainer,
                chosenUsers: _userCheckboxItemList);
          });
    });
  }
}
