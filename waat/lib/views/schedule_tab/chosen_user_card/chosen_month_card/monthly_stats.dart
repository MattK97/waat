import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:newappc/globals/styles/paddings.dart';

class MonthlyStats extends StatelessWidget {
  final String totalTimeBySchedule;
  MonthlyStats({this.totalTimeBySchedule});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: allSixteen,
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(bottom: 8, top: 8),
                child: Text(
                  AppLocalizations.of(context).total_time_by_scheduler.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                  textAlign: TextAlign.center,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      totalTimeBySchedule,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ));
  }
}
