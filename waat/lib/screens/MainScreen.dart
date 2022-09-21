import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/globals/styles/colors.dart';
import 'package:newappc/models/ColorM.dart';
import 'package:newappc/models/Team.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/models/app_version.dart';
import 'package:newappc/notifiers/AnnouncementsNotifier.dart';
import 'package:newappc/notifiers/MeetingNotifier.dart';
import 'package:newappc/notifiers/SchedulesNotifier.dart';
import 'package:newappc/notifiers/TaskContainerNotifier.dart';
import 'package:newappc/notifiers/UsersNotifier.dart';
import 'package:newappc/notifiers/user_data_notifier.dart';
import 'package:newappc/rest/services/announcement_services.dart';
import 'package:newappc/rest/services/chat_services.dart';
import 'package:newappc/rest/services/meeting_services.dart';
import 'package:newappc/rest/services/schedule_services.dart';
import 'package:newappc/rest/services/task_services.dart';
import 'package:newappc/rest/services/team_services.dart';
import 'package:newappc/rest/services/user_services.dart';
import 'package:newappc/services/AuthService.dart';
import 'package:newappc/services/PushNotificationService.dart';
import 'package:newappc/views/news_tab/news_tab.dart';
import 'package:newappc/views/schedule_tab/chosen_user_card/chosen_user_card.dart';
import 'package:newappc/views/schedule_tab/schedule_tab.dart';
import 'package:newappc/views/schedule_tab/schedule_tiles/tiles/schedule_tile_list.dart';
import 'package:newappc/views/settings_tab/settings_tab.dart';
import 'package:newappc/views/task_tab/task_tab.dart';
import 'package:newappc/web_views/web_main_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../views/chat_tab/chat_tab.dart';

AnnouncementServices announcementServices = AnnouncementServices();
UserServices userServices = UserServices();
ChatServices chatServices = ChatServices();
MeetingServices meetingServices = MeetingServices();
ScheduleServices scheduleServices = ScheduleServices();
TaskServices taskServices = TaskServices();
TeamServices teamServices = TeamServices();

final authServiceViewModel = ChangeNotifierProvider.autoDispose<AuthService>((ref) {
  return AuthService.instance();
});
final pushNotificationProvider = ChangeNotifierProvider<PushNotificationService>((ref) {
  return PushNotificationService.instance(ref.read);
});

final appUserProvider = Provider((ref) => ref
    .read(usersNotifier)
    .userList
    .firstWhere((element) => element.userID == ref.read(authServiceViewModel).user.uid));
final teamListProvider =
    StateProvider.autoDispose<List<Team>>((ref) => ref.watch(userDataNotifier).userTeamList);
final colorListProvider =
    StateProvider.autoDispose<List<ColorM>>((ref) => ref.watch(userDataNotifier).colorList);
final chosenTeamProvider = StateProvider<Team>((ref) => ref.watch(userDataNotifier).chosenTeam);
final isChatEnabledProvider =
    StateProvider.autoDispose<bool>((ref) => ref.watch(userDataNotifier).isChatEnabled);

final bottomNavigationBarIndexProvider = StateProvider.autoDispose<int>((_) => 0);
final chatScreenChosenUserProvider = StateProvider.autoDispose<User>((_) => User());
final unreadMessagesCounterProvider = StateProvider.autoDispose<int>((_) => 0);
final isModeratorProvider = StateProvider.autoDispose<bool>((ref) {
  return ref.watch(usersNotifier).userList == null
      ? false
      : ref
          .watch(usersNotifier)
          .userList
          .firstWhere((element) => element.userID == ref.watch(authServiceViewModel).user.uid)
          .isModerator;
});

final announcementsNotifier = ChangeNotifierProvider<AnnouncementsNotifier>((ref) {
  final team = ref.watch(chosenTeamProvider.state).state;
  return AnnouncementsNotifier(team);
});
final schedulesNotifier = ChangeNotifierProvider<SchedulesNotifier>((ref) {
  final team = ref.watch(chosenTeamProvider.state).state;
  return SchedulesNotifier(team);
});
final usersNotifier = ChangeNotifierProvider<UsersNotifier>((ref) {
  return UsersNotifier(ref: ref.read);
});
final tasksContainerNotifier = ChangeNotifierProvider<TasksContainerNotifier>((ref) {
  final team = ref.watch(chosenTeamProvider.state).state;
  return TasksContainerNotifier(team);
});
final meetingNotifier = ChangeNotifierProvider<MeetingNotifier>((ref) {
  final team = ref.watch(chosenTeamProvider.state).state;
  return MeetingNotifier(team);
});
// final workTimeNotifier = ChangeNotifierProvider.autoDispose<WorkTimeNotifier>((ref) {
//   final team = ref.watch(chosenTeamProvider).state;
//   return WorkTimeNotifier(team: team);
// });
final userDataNotifier = Provider<UserDataNotifier>((ref) {
  return UserDataNotifier();
});

//final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class MainScreen extends ConsumerStatefulWidget {
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> with WidgetsBindingObserver {
  Future<List<dynamic>> future;
  bool assignInitialDataToNotifiers = true;

  @override
  void initState() {
    super.initState();
    Jiffy.locale(Platform.localeName.split('_')[0]);
    ref.read(pushNotificationProvider).checkPermission();
    future = Future(() async {
      final AppVersion appVersion =
          await userServices.getRecentAppVersion().then((value) => value.data);
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      final teamList = await userServices.fetchUserTeams().then((value) => value.data);
      final teamId = teamList[0].teamId;
      final month = DateTime.now().month;
      final year = DateTime.now().year;
      return Future.wait([
        Future(() => version == appVersion.versionNum),
        Future(() => appVersion.isChatEnabled),
        Future(() => teamList),
        Future(() => teamList[0]),
        teamServices.fetchTeamMembers(teamId).then((value) => value.data),
        announcementServices.fetchAnnouncements(teamId, month).then((value) => value.data),
        meetingServices.fetchMeetings(teamId, month).then((value) => value.data),
        scheduleServices.fetchSchedules(teamId, month, year).then((value) => value.data),
        scheduleServices.fetchScheduleSwapHistory(teamId, month).then((value) => value.data),
        taskServices.fetchTaskContainer(teamId).then((value) => value.data),
        userServices.fetchColors().then((value) => value.data),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: future,
        builder: (context, data) {
          if (!data.hasData)
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: primaryTeal,
                ),
              ),
            );

          if (!data.data[0]) return _update();
          return Consumer(
            builder: (context, ref, _) {
              if (assignInitialDataToNotifiers) {
                ref.watch(userDataNotifier).isChatEnabled = data.data[1];
                ref.watch(userDataNotifier).userTeamList = data.data[2];
                ref.watch(userDataNotifier).chosenTeam = data.data[3];
                ref.watch(usersNotifier).userList = data.data[4];
                ref.watch(announcementsNotifier).announcementList = data.data[5];
                ref.watch(meetingNotifier).meetingList = data.data[6];
                ref.watch(schedulesNotifier).scheduleList = data.data[7];
                ref.watch(schedulesNotifier).scheduleSwapHistoryList = data.data[8];
                ref.watch(tasksContainerNotifier).taskContainerList = data.data[9];
                ref.watch(userDataNotifier).colorList = data.data[10];
              }
              assignInitialDataToNotifiers = false;
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: kIsWeb ? WebMainScreen() : BottomNavigationScreen(),
              );
            },
          );
        });
  }

  Widget _circularProgressIndicator() {
    return Scaffold(
      body: Center(
          child: CircularProgressIndicator(
        color: primaryTeal,
      )),
    );
  }

  Widget _error() {
    return Center(child: const Text('Oops'));
  }

  Widget _update() {
    return Scaffold(
      body: Center(
        child: Text("Please update an app"),
      ),
    );
  }
}

class BottomNavigationScreen extends ConsumerStatefulWidget {
  @override
  _BottomNavigationScreen createState() => _BottomNavigationScreen();
}

class _BottomNavigationScreen extends ConsumerState<BottomNavigationScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        if (_selectedIndex == index) {
          ref.read(newsTabMainWidgetProvider.state).state = NewsTab();
        }
        break;
      case 1:
        if (_selectedIndex == index) {
          ref.read(taskTabMainWidgetProvider.state).state = TasksTab();
        }
        break;
      case 2:
        if (_selectedIndex == index) {
          ref.read(scheduleTabMainWidgetProvider.state).state = ScheduleTileList();
        }
        break;
    }
    _selectedIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final bottomNavigationBarIndex = ref.watch(bottomNavigationBarIndexProvider.state);
        final isChatEnabled = ref.watch(isChatEnabledProvider.state).state;
        return Container(
          child: Scaffold(
              backgroundColor: Colors.grey[50],
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(5),
                child: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.grey[50],
                ),
              ),
              // key: scaffoldKey,
              body: Stack(
                children: <Widget>[
                  new Offstage(
                    offstage: bottomNavigationBarIndex.state != 0,
                    child: new TickerMode(
                      enabled: bottomNavigationBarIndex.state == 0,
                      child: NewsTabAnimatedSwitcher(),
                    ),
                  ),
                  new Offstage(
                    offstage: bottomNavigationBarIndex.state != 1,
                    child: new TickerMode(
                      enabled: bottomNavigationBarIndex.state == 1,
                      child: TasksTabAnimatedSwitcher(),
                    ),
                  ),
                  new Offstage(
                    offstage: bottomNavigationBarIndex.state != 2,
                    child: new TickerMode(
                      enabled: bottomNavigationBarIndex.state == 2,
                      child: ScheduleTab(),
                    ),
                  ),
                  new Offstage(
                    offstage: bottomNavigationBarIndex.state != 3,
                    child: new TickerMode(
                        enabled: bottomNavigationBarIndex.state == 3,
                        child: isChatEnabled ? ChatTab() : ChatNotEnabled() //WallTab()
                        ),
                  ),
                  new Offstage(
                    offstage: bottomNavigationBarIndex.state != 4,
                    child: new TickerMode(
                        enabled: bottomNavigationBarIndex.state == 4,
                        child: SettingsTabAnimatedSwitcher()),
                  ),
                ],
              ),
              bottomNavigationBar: Consumer(
                builder: (context, ref, _) {
                  final pushN = ref.watch(pushNotificationProvider);
                  final scheduleTabMainWidget = ref.watch(scheduleTabMainWidgetProvider.state);

                  return CupertinoTabBar(
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        label: AppLocalizations.of(context).news,
                        icon: Badge(
                          showBadge: pushN.shouldUpdate && bottomNavigationBarIndex.state != 0,
                          badgeContent: Text(
                            "!",
                            style: TextStyle(color: Colors.white),
                          ),
                          child: bottomNavigationBarIndex.state == 0
                              ? Icon(CupertinoIcons.house_alt_fill)
                              : Icon(CupertinoIcons.house_alt),
                        ),
                      ),
                      BottomNavigationBarItem(
                        label: AppLocalizations.of(context).tasks,
                        icon: bottomNavigationBarIndex.state == 1
                            ? Icon(CupertinoIcons.tag_fill)
                            : Icon(CupertinoIcons.tag),
                      ),
                      BottomNavigationBarItem(
                        label: AppLocalizations.of(context).schedule,
                        icon: bottomNavigationBarIndex.state == 2
                            ? Icon(CupertinoIcons.person_fill)
                            : Icon(CupertinoIcons.person),
                      ),
                      BottomNavigationBarItem(
                        label: AppLocalizations.of(context).chat,
                        icon: Badge(
                          showBadge: pushN.newMessagesCounter == 0 ? false : true,
                          badgeContent: Text(
                            pushN.newMessagesCounter.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          child: bottomNavigationBarIndex.state == 3
                              ? Icon(CupertinoIcons.chat_bubble_fill)
                              : Icon(CupertinoIcons.chat_bubble),
                        ),
                      ),
                      BottomNavigationBarItem(
                        label: AppLocalizations.of(context).settings,
                        icon: bottomNavigationBarIndex.state == 4
                            ? Icon(CupertinoIcons.line_horizontal_3)
                            : Icon(CupertinoIcons.line_horizontal_3),
                      ),
                    ],
                    currentIndex: bottomNavigationBarIndex.state,
                    activeColor: Colors.teal[400],
                    onTap: (index) {
                      if (index == 2 && scheduleTabMainWidget.state.runtimeType == ChosenUserCard) {
                      } else
                        bottomNavigationBarIndex.state = index;
                      _onItemTapped(index);
                    },
                  );
                },
              )),
        );
      },
    );
  }
}

class ChatNotEnabled extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("We're sorry but chat is currently disabled"),
    );
  }
}
