import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/globals/widgets/custom_section_title.dart';
import 'package:newappc/globals/widgets/custom_titled_container.dart';
import 'package:newappc/views/news_tab/calendar/calendar_widgets/calendar_holiday_builder.dart';
import 'package:newappc/views/news_tab/calendar/calendar_widgets/calendar_marker.dart';
import 'package:newappc/views/news_tab/calendar/calendar_widgets/calendar_selected_day_builder.dart';
import 'package:newappc/views/news_tab/calendar/calendar_widgets/calendar_today_builder.dart';
import 'package:newappc/views/news_tab/calendar/chosen_day_widgets/chosen_day.dart';
import 'package:newappc/views/news_tab/calendar/viewmodel/calendar_providers.dart';
import 'package:newappc/views/news_tab/meeting_creator/meeting_creator.dart';
import 'package:newappc/web_views/calendar_tab/web_calendar_tab.dart';
import 'package:table_calendar/table_calendar.dart';

class WebCalendar extends StatefulWidget {
  @override
  _WebCalendar createState() => _WebCalendar();
}

class _WebCalendar extends State<WebCalendar> with TickerProviderStateMixin {
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
        final webCalendarTabMainWidget = ref.watch(webCalendarTabMainWidgetProvider.state);
        final calendarSelectedDay = ref.watch(calendarSelectedDayProvider.state);
        final calendarFocusedDay = ref.watch(calendarFocusedDayProvider.state);

        return CustomTitledContainer(
          customSectionTitle: CustomSectionTitle(
            disableRightIcon: false,
            leftIcon: CupertinoIcons.calendar,
            rightIcon: CupertinoIcons.add,
            color: Colors.teal[400],
            title: 'Calendar',
            //TODO LOCALIZATION
            onPressed: () {
              webCalendarTabMainWidget.state = MeetingCreator();
            },
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: TableCalendar(
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
                            listOfItems: listOfItems,
                          );
                        },
                        headerTitleBuilder: (context, date) {
                          return Column(
                            children: [
                              Text(
                                '${Jiffy(date).MMMM.toUpperCase()}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .copyWith(color: Colors.black),
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
                        selectedBuilder: (context, date, _) =>
                            CalendarSelectedDayBuilder(date: date),
                        holidayBuilder: (context, date, _) => CalendarHolidayBuilder(date: date),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 32, bottom: 32),
                  child: Container(
                      width: 1, height: MediaQuery.of(context).size.height, color: Colors.grey),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.height,
                  child: ChosenDay(
                    calendarFocusedDay: calendarFocusedDay.state,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
