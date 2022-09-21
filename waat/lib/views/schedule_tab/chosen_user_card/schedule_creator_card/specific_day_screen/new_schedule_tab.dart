import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/globals/widgets/custom_action_button.dart';
import 'package:newappc/globals/widgets/custom_expandable_card_container.dart';
import 'package:newappc/globals/widgets/custom_section_title.dart';
import 'package:newappc/globals/widgets/custom_titled_container.dart';
import 'package:newappc/models/Schedule.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/models/date_time_checkbox_item.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_creator_card/schedule_creator/week_picker/viewmodel/week_picker_providers.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_creator_card/specific_day_screen/viewmodel/specific_day_screen_providers.dart';

class NewScheduleTab extends ConsumerStatefulWidget {
  final User user;
  final Schedule schedule;
  final DateTime dateTime;
  final bool isModerator;

  NewScheduleTab({this.user, this.schedule, this.dateTime, this.isModerator});

  @override
  _NewScheduleTabState createState() => _NewScheduleTabState();
}

class _NewScheduleTabState extends ConsumerState<NewScheduleTab> {
  DateTime _startTime;
  DateTime _stopTime;
  bool _isHoliday = false;
  bool _isSickLeave = false;
  bool _isWeekDayPickerExpanded = false;
  List<DateTimeCheckboxItem> dateTimeCheckboxItemList;

  @override
  void initState() {
    super.initState();
    dateTimeCheckboxItemList = [];
    _initDateTimeCheckboxItemList();
    if (widget.schedule != null) {
      _startTime = widget.schedule.start;
      _stopTime = widget.schedule.stop;
      _isHoliday = widget.schedule.holiday;
      _isSickLeave = widget.schedule.sickLeave;
    } else {
      _startTime = DateTime(widget.dateTime.year, widget.dateTime.month, widget.dateTime.day, 8, 0);
      _stopTime = DateTime(widget.dateTime.year, widget.dateTime.month, widget.dateTime.day, 15, 0);
    }
  }

  void _initDateTimeCheckboxItemList() {
    for (int i = 0; i < 7; i++) {
      dateTimeCheckboxItemList.add(DateTimeCheckboxItem(
          dateTime: ref.read(weekPickerViewModelProvider).creatorVisibleDays[i],
          isSelected: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CustomTitledContainer(
          customSectionTitle: CustomSectionTitle(
              disableRightIcon: true,
              leftIcon: CupertinoIcons.time,
              color: Colors.teal[400],
              title: AppLocalizations.of(context).new_schedule),
          child: widget.schedule != null && (widget.schedule.confirmation && !widget.isModerator)
              ? AbsorbPointer(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .moderator_right_required_to_edit_confirmed_schedule,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Opacity(opacity: 0.5, child: _content()),
                    ],
                  ),
                )
              : _content()),
    );
  }

  Widget _content() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 16,
        ),
        AnimatedSize(
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          child: Column(
            children: [
              _isHoliday || _isSickLeave
                  ? Container()
                  : Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              Text(AppLocalizations.of(context).start,
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                  height: 100,
                                  child: CupertinoDatePicker(
                                    initialDateTime: _startTime,
                                    use24hFormat: true,
                                    mode: CupertinoDatePickerMode.time,
                                    onDateTimeChanged: (dateTime) {
                                      setState(() {
                                        _startTime = dateTime;
                                      });
                                    },
                                  )),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context).stop,
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                  height: 100,
                                  child: CupertinoDatePicker(
                                    initialDateTime: _stopTime,
                                    use24hFormat: true,
                                    mode: CupertinoDatePickerMode.time,
                                    minimumDate: _startTime,
                                    onDateTimeChanged: (dateTime) {
                                      setState(() {
                                        _stopTime = dateTime;
                                      });
                                    },
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
              const SizedBox(
                height: 16,
              ),
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.teal[400]),
                child: CheckboxListTile(
                    activeColor: Colors.teal[400],
                    title: Text(AppLocalizations.of(context).day_off,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    value: _isHoliday,
                    onChanged: (value) {
                      setState(() {
                        _isHoliday = value;
                        _isSickLeave = false;
                      });
                    }),
              ),
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.teal[400]),
                child: CheckboxListTile(
                    activeColor: Colors.teal[400],
                    title: Text(AppLocalizations.of(context).sick_leave,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    value: _isSickLeave,
                    onChanged: (value) {
                      setState(() {
                        _isHoliday = false;
                        _isSickLeave = value;
                      });
                    }),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        ListTile(
          onTap: () {
            setState(() {
              _isWeekDayPickerExpanded = !_isWeekDayPickerExpanded;
            });
          },
          leading: Icon(
            _isWeekDayPickerExpanded ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down,
            color: Colors.black,
          ),
          title: Text(
            AppLocalizations.of(context).duplicate_schedule_for_next_days,
            style: TextStyle(color: Colors.black),
          ),
        ),
        CustomExpandableCardContainer(
          isExpanded: _isWeekDayPickerExpanded,
          collapsedChild: Container(),
          expandedChild: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 16,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 2.0,
                ),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: dateTimeCheckboxItemList.length,
                    itemBuilder: (context, index) {
                      DateTimeCheckboxItem dateTimeCheckboxItem = dateTimeCheckboxItemList[index];
                      return Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.teal[400]),
                        child: CheckboxListTile(
                          activeColor: Colors.teal[400],
                          title: Text(Jiffy(dateTimeCheckboxItem.dateTime).EEEE),
                          value: dateTimeCheckboxItem.isSelected,
                          onChanged: (bool value) {
                            setState(() {
                              dateTimeCheckboxItem.isSelected = value;
                            });
                          },
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        Consumer(builder: (context, ref, child) {
          final specificDayScreenVM = ref.watch(specificDayScreenViewModel);
          return CustomActionButton(
            onPressed: () async {
              if (await specificDayScreenVM.operateOnSchedule(
                  chosenSchedule: widget.schedule,
                  user: widget.user,
                  start: _startTime,
                  stop: _stopTime,
                  isHoliday: _isHoliday,
                  isSickLeave: _isSickLeave,
                  dateTimeCheckedItemList:
                      dateTimeCheckboxItemList.where((element) => element.isSelected).toList())) {
                Navigator.of(context).pop();
              }
            },
          );
        })
      ],
    );
  }
}
