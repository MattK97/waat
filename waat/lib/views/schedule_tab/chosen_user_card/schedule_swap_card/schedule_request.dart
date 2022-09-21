import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/globals/widgets/custom_section_title.dart';
import 'package:newappc/globals/widgets/custom_titled_container.dart';
import 'package:newappc/models/Schedule.dart';
import 'package:newappc/models/ScheduleSwap.dart';
import 'package:newappc/models/ScheduleSwapHistory.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_swap_card/schedule_request_confirmation_dialog.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/schedule_swap_card/schedule_request_table_headers.dart';

import '../../../../main.dart';

class ScheduleRequests extends StatefulWidget {
  final User user;

  ScheduleRequests({this.user});

  @override
  _ScheduleRequests createState() => _ScheduleRequests();
}

class _ScheduleRequests extends State<ScheduleRequests> {
  Icon _getIcon(bool agreement) {
    if (agreement == null)
      return Icon(CupertinoIcons.question);
    else if (agreement)
      return Icon(CupertinoIcons.checkmark, color: Colors.teal[600]);
    else
      return Icon(CupertinoIcons.clear, color: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final scheduleList = ref.watch(schedulesNotifier).scheduleList;
      final userList = ref.watch(usersNotifier).userList;
      final authVM = ref.watch(authServiceViewModel);
      final scheduleListWithSwaps = scheduleList
          .where(
              (element) => element.scheduleSwaps == null ? false : element.scheduleSwaps.isNotEmpty)
          .toList();
      final scheduleListWithSwapsOnlyForChosenUser = [];
      scheduleListWithSwaps.forEach((scheduleWithSwap) {
        scheduleWithSwap.scheduleSwaps.forEach((element) {
          if (element.requesterId == widget.user.userID ||
              scheduleList
                      .firstWhere((schedule) => schedule.id == element.firstScheduleId)
                      .userID ==
                  widget.user.userID) {
            scheduleListWithSwapsOnlyForChosenUser.add(scheduleWithSwap);
          }
        });
      });

      final historyRequests = ref
          .watch(schedulesNotifier)
          .scheduleSwapHistoryList
          .where((element) =>
              element.firstScheduleUserId == widget.user.userID ||
              element.secondScheduleUserId == widget.user.userID)
          .toList();

      return CustomTitledContainer(
        customSectionTitle: CustomSectionTitle(
          disableRightIcon: true,
          leftIcon: CupertinoIcons.arrow_swap,
          color: Colors.teal[400],
          title: AppLocalizations.of(context).schedule_swap,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              ScheduleRequestTableHeaders(),
              SizedBox(
                height: 8,
              ),
              ListView.builder(
                  padding: EdgeInsets.all(0),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: scheduleListWithSwapsOnlyForChosenUser.length,
                  itemBuilder: (context, index) {
                    Schedule scheduleWithSwap = scheduleListWithSwapsOnlyForChosenUser[index];
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: scheduleWithSwap.scheduleSwaps.length,
                        itemBuilder: (context, index) {
                          ScheduleSwap scheduleSwap = scheduleWithSwap.scheduleSwaps[index];
                          User requesterUser = userList
                              .firstWhere((element) => element.userID == scheduleSwap.requesterId);
                          Schedule requestersSchedule = scheduleList
                              .firstWhere((element) => element.id == scheduleSwap.secondScheduleId);
                          User requestedUser = userList
                              .firstWhere((element) => element.userID == scheduleWithSwap.userID);

                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 4, bottom: 4),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        Jiffy(scheduleWithSwap.start).MMMd,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(children: [
                                        Text(
                                          requesterUser.userID == authVM.user.uid
                                              ? 'You'
                                              : requesterUser.firstName,
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        requestersSchedule.holiday || requestersSchedule.sickLeave
                                            ? Text(
                                                '${requestersSchedule.holiday ? AppLocalizations.of(context).day_off : AppLocalizations.of(context).sick_leave}',
                                                textAlign: TextAlign.center,
                                              )
                                            : Text(
                                                '${Jiffy(requestersSchedule.start).Hm}\n${Jiffy(requestersSchedule.stop).Hm}',
                                                textAlign: TextAlign.center,
                                              ),
                                      ]),
                                    ),
                                    Expanded(
                                      child: Column(children: [
                                        Text(
                                          requestedUser.userID == authVM.user.uid
                                              ? 'You'
                                              : requestedUser.firstName,
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        scheduleWithSwap.holiday || scheduleWithSwap.sickLeave
                                            ? Text(
                                                '${scheduleWithSwap.holiday ? AppLocalizations.of(context).day_off : AppLocalizations.of(context).sick_leave}',
                                                textAlign: TextAlign.center,
                                              )
                                            : Text(
                                                '${Jiffy(scheduleWithSwap.start).Hm}\n${Jiffy(scheduleWithSwap.stop).Hm}',
                                                textAlign: TextAlign.center,
                                              ),
                                      ]),
                                    ),
                                    scheduleSwap.requesterId == widget.user.userID
                                        ? Expanded(
                                            child: IconButton(
                                              icon: Icon(CupertinoIcons.question_diamond,
                                                  color: Colors.grey[600]),
                                              onPressed: null,
                                            ),
                                          )
                                        : Expanded(
                                            child: scheduleSwap.agreement == null
                                                ? IconButton(
                                                    icon: Icon(
                                                        CupertinoIcons.exclamationmark_square,
                                                        color: Colors.orange),
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return ScheduleRequestConfirmationDialog(
                                                              firstSchedule: scheduleWithSwap,
                                                              secondSchedule: requestersSchedule,
                                                              scheduleSwap: scheduleSwap,
                                                            );
                                                          });
                                                    },
                                                  )
                                                : _getIcon(scheduleSwap.agreement),
                                          ),
                                  ],
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        });
                  }),
              ListView.builder(
                padding: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: historyRequests.length,
                itemBuilder: (context, index) {
                  ScheduleSwapHistory scheduleSwapHistory = historyRequests[index];
                  User requesterUser = userList.firstWhere(
                      (element) => element.userID == scheduleSwapHistory.secondScheduleUserId);
                  User requestedUser = userList.firstWhere(
                      (element) => element.userID == scheduleSwapHistory.firstScheduleUserId);
                  DateTime requestedUserScheduleStart = scheduleSwapHistory.firstScheduleStart;
                  DateTime requestedUserScheduleStop = scheduleSwapHistory.firstScheduleStop;
                  DateTime requesterUserScheduleStart = scheduleSwapHistory.secondScheduleStart;
                  DateTime requesterUserScheduleStop = scheduleSwapHistory.secondScheduleStop;
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                Jiffy(requestedUserScheduleStart).MMMd,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Column(children: [
                                Text(
                                  requesterUser.userID == authVM.user.uid
                                      ? 'You'
                                      : requesterUser.firstName,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  '${Jiffy(requesterUserScheduleStart).Hm}\n${Jiffy(requesterUserScheduleStop).Hm}',
                                  textAlign: TextAlign.center,
                                ),
                              ]),
                            ),
                            Expanded(
                              child: Column(children: [
                                Text(
                                  requestedUser.userID == authVM.user.uid
                                      ? 'You'
                                      : requestedUser.firstName,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  '${Jiffy(requestedUserScheduleStart).Hm}\n${Jiffy(requestedUserScheduleStop).Hm}',
                                  textAlign: TextAlign.center,
                                ),
                              ]),
                            ),
                            Expanded(
                              child: scheduleSwapHistory.agreement == null
                                  ? IconButton(
                                      icon: Icon(CupertinoIcons.exclamationmark_square,
                                          color: Colors.orange),
                                      onPressed: () {},
                                    )
                                  : _getIcon(scheduleSwapHistory.agreement),
                            ),
                          ],
                        ),
                      ),
                      Divider()
                    ],
                  );
                },
              )
            ],
          ),
        ),
      );
    });
  }
}
