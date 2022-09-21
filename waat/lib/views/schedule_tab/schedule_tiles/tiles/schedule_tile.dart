import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/additional_widgets/color_manipulator.dart';
import 'package:newappc/additional_widgets/hex_color.dart';
import 'package:newappc/models/Schedule.dart';
import 'package:newappc/views/schedule_tab/schedule_tiles/tiles/viewmodel/schedule_tiles_providers.dart';

import 'schedule_tile_pattern.dart';

class ScheduleTile extends ConsumerWidget {
  final user;

  ScheduleTile(this.user);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tilesVM = ref.watch(scheduleTileListViewModel);
    Map<int, Schedule> map = tilesVM.createSpecificUserWeeklySchedule(user);
    return Card(
      elevation: 5,
      color: ColorManipulator.lighten(HexColor(user?.color), 0.04),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Center(
                child: Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: Icon(CupertinoIcons.ellipsis, color: Colors.transparent),
                            flex: 1),
                        Expanded(
                            flex: 8,
                            child: Center(
                              child: Text(
                                user == null
                                    ? "DEFAULT_USER"
                                    : user?.firstName.toString().toUpperCase(),
                                style: Theme.of(context).textTheme.headline4.copyWith(
                                    color: ColorManipulator.darken(HexColor(user?.color), 0.3)),
                              ),
                            )),
                        Expanded(
                            child: Icon(CupertinoIcons.ellipsis,
                                color: ColorManipulator.darken(HexColor(user?.color))),
                            flex: 1),
                      ],
                    ))),
            ScheduleTilePattern(
              map: map,
              user: user,
            ),
          ],
        ),
      ),
    );
  }
}
