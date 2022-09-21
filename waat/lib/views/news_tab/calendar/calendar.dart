import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/globals/widgets/custom_section_title.dart';
import 'package:newappc/globals/widgets/custom_titled_container.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/news_tab/calendar/calendar_widgets/calendar_holiday_builder.dart';
import 'package:newappc/views/news_tab/calendar/calendar_widgets/calendar_today_builder.dart';
import 'package:newappc/views/news_tab/calendar/viewmodel/calendar_providers.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../main.dart';
import '../meeting_creator/meeting_creator.dart';
import '../news_tab.dart';
import 'calendar_widgets/calendar_marker.dart';
import 'calendar_widgets/calendar_selected_day_builder.dart';
import 'chosen_day_widgets/chosen_day.dart';

class NewsTabCalendar extends StatefulWidget {
  @override
  _NewsTabCalendar createState() => _NewsTabCalendar();
}

class _NewsTabCalendar extends State<NewsTabCalendar> with TickerProviderStateMixin {
  final kNow = DateTime.now();
  var kFirstDay;
  var kLastDay;

  @override
  void initState() {
    kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
    kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final calendarVM = ref.watch(calendarViewModel);
        final newsTabMainWidget = ref.watch(newsTabMainWidgetProvider.state);
        final calendarSelectedDay = ref.watch(calendarSelectedDayProvider.state);
        final calendarFocusedDay = ref.watch(calendarFocusedDayProvider.state);
        final user = ref
            .watch(usersNotifier)
            .userList
            .firstWhere((element) => element.userID == ref.watch(authServiceViewModel).user.uid);

        return CustomTitledContainer(
          customSectionTitle: CustomSectionTitle(
            disableRightIcon: false,
            leftIcon: CupertinoIcons.calendar,
            rightIcon: CupertinoIcons.add,
            color: Colors.teal[400],
            title: AppLocalizations.of(context).calendar,
            onPressed: () {
              newsTabMainWidget.state = MeetingCreator();
            },
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: TableCalendar(
                  locale: Platform.localeName.split('_')[0],
                  selectedDayPredicate: (day) {
                    return isSameDay(calendarSelectedDay.state, day);
                  },
                  holidayPredicate: calendarVM.hasScheduleForGivenDay,
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  calendarFormat: CalendarFormat.month,
                  focusedDay: calendarFocusedDay.state,
                  eventLoader: calendarVM.getTasksAndMeetingsForDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                    calendarVM.onDaySelected(selectedDay, focusedDay);
                    calendarFocusedDay.state = focusedDay;
                    calendarSelectedDay.state = selectedDay;
                  },
                  rowHeight: 50,
                  availableGestures: AvailableGestures.horizontalSwipe,
                  onPageChanged: (DateTime day) {
                    calendarFocusedDay.state = day;
                    calendarSelectedDay.state = day;
                  },
                  availableCalendarFormats: const {
                    CalendarFormat.month: '',
                  },
                  calendarStyle: CalendarStyle(
                    markersMaxCount: 1,
                    rangeHighlightColor: Colors.teal[200],
                    outsideDaysVisible: false,
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(),
                  headerStyle: HeaderStyle(
                    leftChevronIcon: Icon(
                      CupertinoIcons.chevron_left,
                      color: Colors.black,
                    ),
                    rightChevronIcon: Icon(
                      CupertinoIcons.chevron_right,
                      color: Colors.black,
                    ),
                    formatButtonVisible: false,
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, listOfItems) {
                      if (listOfItems.isEmpty) return null;
                      return CalendarMarker(
                        user: user,
                        listOfItems: listOfItems,
                      );
                    },
                    headerTitleBuilder: (context, date) {
                      return Column(
                        children: [
                          Text(
                            '${Jiffy(date).MMMM.toUpperCase()}',
                            style:
                                Theme.of(context).textTheme.headline2.copyWith(color: Colors.black),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text('${Jiffy(date).year}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(color: Colors.black)),
                          SizedBox(
                            height: 4,
                          ),
                        ],
                      );
                    },
                    todayBuilder: (context, date, focusedDay) => CalendarTodayBuilder(
                      date: date,
                    ),
                    selectedBuilder: (context, date, _) => CalendarSelectedDayBuilder(date: date),
                    holidayBuilder: (context, date, _) => CalendarHolidayBuilder(date: date),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Divider(
                    color: Colors.grey,
                  )),
              ChosenDay(
                calendarFocusedDay: calendarFocusedDay.state,
              ),
            ],
          ),
        );
      },
    );
  }
}
