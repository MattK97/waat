import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/views/schedule_tab/schedule_tiles/tiles/schedule_tile_list.dart';

final AutoDisposeStateProvider<Widget> scheduleTabMainWidgetProvider =
    StateProvider.autoDispose((ref) => ScheduleTileList());

class ScheduleTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleTabMainWidget = ref.watch(scheduleTabMainWidgetProvider.state);
    return AnimatedSwitcher(
      duration: Duration(seconds: 1),
      switchInCurve: Curves.bounceIn,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          child: child,
          position: Tween<Offset>(
            begin: Offset(0.0, 2.0),
            end: Offset.zero,
          ).animate(animation),
        );
      },
      child: scheduleTabMainWidget.state,
    );
  }
}
