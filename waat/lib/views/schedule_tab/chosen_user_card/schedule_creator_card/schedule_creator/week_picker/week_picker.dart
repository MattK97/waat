import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_creator_card/schedule_creator/week_picker/viewmodel/week_picker_providers.dart';

class WeekPicker extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekPickerVM = ref.watch(weekPickerViewModelProvider);
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                weekPickerVM.previousWeek();
              },
              child: const Icon(
                CupertinoIcons.chevron_left,
                color: Colors.black,
              ),
            )),
        Expanded(
            flex: 6,
            child: Center(
              child: Text(weekPickerVM.choosedWeekDatesRange,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            )),
        Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                weekPickerVM.nextWeek();
              },
              child: const Icon(
                CupertinoIcons.chevron_right,
                color: Colors.black,
              ),
            ))
      ],
    );
  }
}
