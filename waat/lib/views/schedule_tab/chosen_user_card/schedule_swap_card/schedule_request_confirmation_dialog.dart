import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/styles/radiuses.dart';
import 'package:newappc/models/Schedule.dart';
import 'package:newappc/models/ScheduleSwap.dart';
import 'package:newappc/screens/MainScreen.dart';

class ScheduleRequestConfirmationDialog extends ConsumerWidget {
  final Schedule firstSchedule;
  final Schedule secondSchedule;
  final ScheduleSwap scheduleSwap;

  ScheduleRequestConfirmationDialog({this.firstSchedule, this.secondSchedule, this.scheduleSwap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesN = ref.watch(schedulesNotifier);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      content: Text(
        AppLocalizations.of(context).schedule_swap_decision,
        style: TextStyle(fontSize: 16),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              scheduleSwap.agreement = true;
              schedulesN.updateScheduleSwap(scheduleSwap);
              Navigator.pop(context, true);
            },
            child: Text(
              AppLocalizations.of(context).accept,
              style: TextStyle(color: Colors.teal),
            )),
        TextButton(
          onPressed: () {
            scheduleSwap.agreement = false;
            schedulesN.updateScheduleSwap(scheduleSwap);
            Navigator.pop(context, false);
          },
          child: Text(AppLocalizations.of(context).refuse, style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}
