import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/globals/styles/colors.dart';
import 'package:newappc/views/news_tab/calendar/chosen_day_widgets/custom_tile.dart';
import 'package:newappc/views/news_tab/calendar/viewmodel/calendar_providers.dart';

import 'meeting_list.dart';
import 'task_list.dart';

class ChosenDay extends StatefulWidget {
  final DateTime calendarFocusedDay;

  ChosenDay({this.calendarFocusedDay});

  @override
  _ChosenDayState createState() => _ChosenDayState();
}

class _ChosenDayState extends State<ChosenDay> {
  PageController _pageController = PageController();
  int _chosenPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChosenDayInfo(
          calendarFocusedDay: widget.calendarFocusedDay,
        ),
        TaskList(),
        MeetingList(),
        SizedBox(
          height: 16,
        )
      ],
    );
  }
}

class ChosenDayInfo extends StatelessWidget {
  final DateTime calendarFocusedDay;

  ChosenDayInfo({this.calendarFocusedDay});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 3, child: ByScheduler()),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(right: 32.0, top: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(calendarFocusedDay.day.toString(),
                    style:
                        TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold)),
                Text(Jiffy(calendarFocusedDay).E,
                    style: TextStyle(fontSize: 20, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ByScheduler extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDayVM = ref.watch(chosenDayViewModel);
    return Container(
      child: Center(
          child: currentDayVM.selectedDayUserSchedule == null
              ? CustomTile(
                  tileType: TileType.schedule,
                  title: '-',
                )
              : Builder(builder: (context) {
                  if (currentDayVM.selectedDayUserSchedule.holiday)
                    return CustomTile(
                      iconColor: currentDayVM.selectedDayUserSchedule.confirmation
                          ? Colors.orange[300]
                          : Colors.orange[300].withOpacity(0.5),
                      tileType: TileType.schedule,
                      title: '${AppLocalizations.of(context).day_off.toUpperCase()} '
                          '${currentDayVM.selectedDayUserSchedule.confirmation ? '' : "\n(Not "
                              "Confirmed)"}',
                    );
                  else if (currentDayVM.selectedDayUserSchedule.sickLeave)
                    return CustomTile(
                      iconColor: currentDayVM.selectedDayUserSchedule.confirmation
                          ? Colors.blue[600]
                          : Colors.blue[600].withOpacity(0.5),
                      tileType: TileType.schedule,
                      title: '${AppLocalizations.of(context).sick_leave.toUpperCase()} '
                          '${currentDayVM.selectedDayUserSchedule.confirmation ? '' : "\n(Not "
                              "Confirmed)"}',
                    );
                  else
                    return CustomTile(
                      iconColor: currentDayVM.selectedDayUserSchedule.confirmation
                          ? primaryVinted
                          : primaryVinted.withOpacity(0.5),
                      tileType: TileType.schedule,
                      title:
                          '${Jiffy(currentDayVM.selectedDayUserSchedule.start).Hm} - ${Jiffy(currentDayVM.selectedDayUserSchedule.stop).Hm}'
                          '${currentDayVM.selectedDayUserSchedule.confirmation ? '' : "\n(Not "
                              "Confirmed)"}',
                    );
                })),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int chosenPageIndex;

  const PageIndicator({Key key, this.chosenPageIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.tag_fill,
              size: 16,
              color: chosenPageIndex == 0 ? primaryTeal : Colors.grey[300],
            ),
            SizedBox(
              width: 8,
            ),
            Icon(
              CupertinoIcons.person_3_fill,
              size: 16,
              color: chosenPageIndex == 1 ? primaryPurple : Colors.grey[300],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
