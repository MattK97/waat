import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/globals/widgets/custom_section_title.dart';
import 'package:newappc/globals/widgets/custom_titled_container.dart';
import 'package:newappc/views/news_tab/calendar/calendar_widgets/calendar_chosen_day_schedule_pill_no_border.dart';
import 'package:newappc/views/schedule_tab/schedule_tiles/calendar/viewmodel/schedule_calendar_providers.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleCalendar extends ConsumerStatefulWidget {
  _ScheduleCalendar createState() => _ScheduleCalendar();
}

class _ScheduleCalendar extends ConsumerState<ScheduleCalendar> with TickerProviderStateMixin {
  final kNow = DateTime.now();
  var kFirstDay;
  var kLastDay;

  @override
  void initState() {
    super.initState();
    kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
    kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);
  }

  void _updateVisibleDays(DateTime start) {
    List<DateTime> list = [];
    for (int i = 0; i < 7; i++) {
      var weekday = Jiffy(Jiffy(start).startOf(Units.WEEK)).add(days: i);
      list.add(weekday.dateTime);
    }
    ref.read(scheduleCalendarVisibleDaysProvider).state = list;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return CustomTitledContainer(
          customSectionTitle: CustomSectionTitle(
            leftIcon: CupertinoIcons.clock,
            rightIcon: CupertinoIcons.add,
            disableRightIcon: true,
            color: Colors.teal[400],
            title: AppLocalizations.of(context).weekly_schedule, //TODO LOCALIZATION
          ),
          child: Column(
            children: [
              TableCalendar(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: kNow,
                calendarFormat: CalendarFormat.week,
                rowHeight: 50,
                availableGestures: AvailableGestures.horizontalSwipe,
                startingDayOfWeek: StartingDayOfWeek.monday,
                onPageChanged: _updateVisibleDays,
                availableCalendarFormats: const {
                  CalendarFormat.week: '',
                },
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle().copyWith(color: Colors.teal[300]),
                ),
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
                calendarBuilders: CalendarBuilders(headerTitleBuilder: (context, date) {
                  return Center(
                    child: Text(
                      Jiffy(date).yMMMM.toUpperCase(),
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  );
                }, todayBuilder: (context, date, focusedDay) {
                  return CalendarChosenDaySchedulePillNoBorder(
                      date, Colors.teal[400], BoxDecoration());
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
