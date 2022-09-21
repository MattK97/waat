import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/chosen_month_card/viewmodel/chosen_month_card_providers.dart';

class CustomMonthPicker extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                ref.watch(chosenMonthProvider.state).state =
                    ref.watch(chosenMonthProvider.state).state.subtract(months: 1);
              },
              child: const Icon(
                CupertinoIcons.chevron_left,
                color: Colors.black,
              ),
            )),
        Expanded(
          flex: 6,
          child: Center(
            child: Container(
                padding: EdgeInsets.only(bottom: 8, top: 8),
                child: Text(ref.watch(chosenMonthProvider.state).state.MMMM.toUpperCase(),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center)),
          ),
        ),
        Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                ref.watch(chosenMonthProvider.state).state =
                    ref.watch(chosenMonthProvider.state).state.add(months: 1);
              },
              child: const Icon(
                CupertinoIcons.chevron_right,
                color: Colors.black,
              ),
            )),
      ],
    );
  }
}
