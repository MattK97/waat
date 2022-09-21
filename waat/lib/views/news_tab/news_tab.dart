import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/news_tab/update_info.dart';
import 'package:newappc/views/news_tab/welcome.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'announcements/announcements.dart';
import 'calendar/calendar.dart';

final AutoDisposeStateProvider<Widget> newsTabMainWidgetProvider =
    StateProvider.autoDispose((ref) => NewsTab());

class NewsTabAnimatedSwitcher extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsTabMainWidget = ref.watch(newsTabMainWidgetProvider.state);
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
      child: newsTabMainWidget.state,
    );
  }
}

class NewsTab extends ConsumerStatefulWidget {
  @override
  _NewsTab createState() => _NewsTab();
}

class _NewsTab extends ConsumerState<NewsTab> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  void _onRefresh() async {
    ref.read(announcementsNotifier).fetchAnnouncements(DateTime.now().month);
    ref.read(schedulesNotifier).fetchSchedule(DateTime.now().month, DateTime.now().year);
    ref.read(schedulesNotifier).fetchScheduleSwapHistory(DateTime.now().month);
    ref.read(usersNotifier).fetchTeamUserList();
    ref.read(tasksContainerNotifier).fetchTaskContainerList();
    ref.read(meetingNotifier).fetchMeetingList(DateTime.now().month);
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Consumer(
      builder: (context, ref, child) {
        return SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            enablePullDown: true,
            enablePullUp: false,
            physics: const BouncingScrollPhysics(),
            header: ClassicHeader(
              idleText: AppLocalizations.of(context).pull_to_refresh,
              releaseText: AppLocalizations.of(context).release_me,
              refreshingText: AppLocalizations.of(context).refreshing,
              completeText: AppLocalizations.of(context).ready,
            ),
            child: ListView(
              children: [
                UpdateInfo(),
                Welcome(),
                Announcements(),
                NewsTabCalendar(),
                SizedBox(
                  height: 16,
                )
              ],
            ));
      },
    ));
  }
}
