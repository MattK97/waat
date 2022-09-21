import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/globals/widgets/custom_action_button.dart';
import 'package:newappc/globals/widgets/custom_section_title.dart';
import 'package:newappc/globals/widgets/custom_titled_container.dart';
import 'package:newappc/models/Schedule.dart';
import 'package:newappc/models/ScheduleSwap.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/screens/MainScreen.dart';

class NewScheduleSwapTab extends StatefulWidget {
  final Schedule schedule;
  final DateTime dateTime;
  final User user;

  NewScheduleSwapTab({this.schedule, this.dateTime, this.user});

  @override
  _NewScheduleSwapTabState createState() => _NewScheduleSwapTabState();
}

class _NewScheduleSwapTabState extends State<NewScheduleSwapTab> {
  Schedule _chosenSchedule;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final schedulesN = ref.watch(schedulesNotifier);
      final chosenDaySchedules = schedulesN.scheduleList
          .where((element) =>
              Jiffy(element.start).yMd == Jiffy(widget.dateTime).yMd &&
              element.userID != widget.user.userID &&
              element.confirmation)
          .toList();
      final usersN = ref.watch(usersNotifier);
      bool requestAlreadyExists = false;
      chosenDaySchedules?.forEach((element) {
        element.scheduleSwaps?.forEach((element) {
          if (element.requesterId == widget.user.userID) requestAlreadyExists = true;
        });
      });
      return CustomTitledContainer(
          customSectionTitle: CustomSectionTitle(
            disableRightIcon: true,
            leftIcon: CupertinoIcons.person_2,
            color: Colors.teal[400],
            title: AppLocalizations.of(context).chose_team_member, //TODO ADD LOCALIZATION
          ),
          child: Builder(
            builder: (context) {
              if (widget.schedule == null) {
                return FirstCreateOwnSchedule();
              } else if (!widget.schedule.confirmation) {
                return FirstWaitForScheduleConfirmation();
              } else if (requestAlreadyExists) {
                return RequestAlreadyExist();
              }
              return _newScheduleSwapTabMainContent(chosenDaySchedules, usersN, schedulesN);
            },
          ));
    });
  }

  Widget _newScheduleSwapTabMainContent(
      List<Schedule> chosenDaySchedules, dynamic usersN, dynamic schedulesN) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        chosenDaySchedules.isEmpty
            ? NoSchedulesToRequestSwap()
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: chosenDaySchedules.length,
                itemBuilder: (context, index) {
                  final givenUserSchedule = chosenDaySchedules[index];
                  final givenUser = usersN.userList
                      .firstWhere((element) => element.userID == givenUserSchedule.userID);
                  return Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.teal[400]),
                    child: CheckboxListTile(
                        activeColor: Colors.teal[400],
                        title: Row(
                          children: [
                            Expanded(child: Text(givenUser.firstName)),
                            Expanded(
                                child: Text(
                                    '${Jiffy(givenUserSchedule.start).Hm} - ${Jiffy(givenUserSchedule.stop).Hm}'))
                          ],
                        ),
                        value: _chosenSchedule == givenUserSchedule,
                        onChanged: (value) {
                          if (value) {
                            setState(() {
                              _chosenSchedule = givenUserSchedule;
                            });
                          } else {
                            setState(() {
                              _chosenSchedule = null;
                            });
                          }
                        }),
                  );
                }),
        chosenDaySchedules.isEmpty
            ? Container()
            : CustomActionButton(
                onPressed: () async {
                  final scheduleSwap = ScheduleSwap(
                      firstScheduleId: _chosenSchedule.id,
                      secondScheduleId: widget.schedule.id,
                      requesterId: widget.user.userID);
                  if (await schedulesN.createScheduleSwap(scheduleSwap)) {
                    Navigator.of(context).pop();
                  }
                },
              )
      ],
    );
  }
}

//TODO ADD LOCALIZATION
class RequestAlreadyExist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(64),
        child: Center(
            child: Text(AppLocalizations.of(context).request_already_exists_for_chosen_day)));
  }
}

class FirstCreateOwnSchedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(64),
      child: Center(child: Text(AppLocalizations.of(context).first_create_your_own_schedule)),
    );
  }
}

class FirstWaitForScheduleConfirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(64),
      child: Center(
          child: Text(AppLocalizations.of(context)
              .in_order_to_create_schedule_swap_schedule_must_be_confirmed)),
    );
  }
}

class NoSchedulesToRequestSwap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: EdgeInsets.all(64),
      child: Text(AppLocalizations.of(context).no_schedule_for_given_day_to_request),
    ));
  }
}
