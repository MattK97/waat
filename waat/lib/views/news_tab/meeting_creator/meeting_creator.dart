import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/styles/paddings.dart';
import 'package:newappc/globals/widgets/custom_creator_base.dart';
import 'package:newappc/globals/widgets/custom_date_picker_field.dart';
import 'package:newappc/globals/widgets/custom_input_field.dart';
import 'package:newappc/globals/widgets/custom_section_title.dart';
import 'package:newappc/globals/widgets/custom_time_picker_field.dart';
import 'package:newappc/globals/widgets/custom_user_checkbox_list.dart';
import 'package:newappc/models/meeting.dart';
import 'package:newappc/models/user_checkbox_item.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/news_tab/meeting_creator/viewmodel/meeting_creator_providers.dart';

import '../news_tab.dart';

class MeetingCreator extends ConsumerStatefulWidget {
  final Meeting chosenMeeting;

  MeetingCreator({this.chosenMeeting});

  @override
  _MeetingCreatorState createState() => _MeetingCreatorState();
}

class _MeetingCreatorState extends ConsumerState<MeetingCreator> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _infoController = TextEditingController();
  DateTime _dateTime;
  TimeOfDay _timeOfDay;
  List<UserCheckboxItem> _userCheckboxItemList;
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    if (widget.chosenMeeting != null) {
      _dateTime = widget.chosenMeeting.start;
      _timeOfDay = TimeOfDay.fromDateTime(_dateTime);
      _titleController.text = widget.chosenMeeting.name;
      _infoController.text = widget.chosenMeeting.info;
      _userCheckboxItemList = ref
          .read(usersNotifier)
          .userList
          .map((e) => UserCheckboxItem(e, widget.chosenMeeting.meetingUsersIds.contains(e.userID)))
          .toList();
      _updateButton('');
    } else {
      _userCheckboxItemList =
          ref.read(usersNotifier).userList.map((e) => UserCheckboxItem(e, false)).toList();
    }
  }

  void _refreshTimePicker(TimeOfDay pickedTimeOfDay) {
    setState(() {
      _timeOfDay = pickedTimeOfDay;
    });
    _updateButton('');
  }

  void _refreshDateTimePicker(DateTime pickedDateTime) {
    setState(() {
      _dateTime = pickedDateTime;
    });
    _updateButton('');
  }

  void _updateUserCheckboxList(List<UserCheckboxItem> userCheckBoxList) {
    _userCheckboxItemList = userCheckBoxList;
  }

  void _updateButton(String value) {
    setState(() {
      _isButtonDisabled = _dateTime == null || _timeOfDay == null || _titleController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, WidgetRef ref, Widget child) {
      final meetingCreatorVM = ref.watch(meetingCreatorViewModel);
      final newsTabMainWidget = ref.watch(newsTabMainWidgetProvider.state);
      return CustomCreatorBase(
        isButtonDisabled: _isButtonDisabled,
        title: CustomSectionTitle(
          disableRightIcon: false,
          color: Colors.teal[400],
          leftIcon: CupertinoIcons.person_2,
          rightIcon: CupertinoIcons.clear,
          title: AppLocalizations.of(context).meeting_creator,
          onPressed: () {
            newsTabMainWidget.state = NewsTab();
          },
        ),
        children: [
          Row(
            children: [
              Expanded(
                  child: CustomDatePickerField(
                padding: halfInputFieldPaddingLeft,
                notifyParent: _refreshDateTimePicker,
                pickedDateTime: _dateTime,
              )),
              Expanded(
                  child: CustomTimePickerField(
                padding: halfInputFieldPaddingRight,
                notifyParent: _refreshTimePicker,
                pickedTimeOfDay: _timeOfDay,
              )),
            ],
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
          await meetingCreatorVM.operateOnMeeting(
              chosenMeeting: widget.chosenMeeting,
              title: _titleController.text,
              info: _infoController.text,
              chosenDayDate: _dateTime,
              chosenDayTime: _timeOfDay,
              chosenUsers: _userCheckboxItemList);
        },
      );
    });
  }
}
