import 'package:flutter/cupertino.dart';
import 'package:newappc/views/schedule_tab/schedule_tiles/calendar/schedule_calendar.dart';

import 'co_worker_schedule_tile.dart';
import 'current_user_schedule_tile.dart';

class ScheduleTileList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ScheduleCalendar(),
        CurrentUserScheduleTile(),
        CoWorkersScheduleTile(),
        const SizedBox(height: 32)
      ],
    );
  }
}
