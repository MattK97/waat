import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/web_views/calendar_tab/calendar.dart';

final AutoDisposeStateProvider<Widget> webCalendarTabMainWidgetProvider =
    StateProvider.autoDispose((ref) => WebCalendarTab());

class WebCalendarAnimatedSwitcher extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webCalendarTabMainWidget = ref.watch(webCalendarTabMainWidgetProvider.state);
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
      child: webCalendarTabMainWidget.state,
    );
  }
}

class WebCalendarTab extends StatefulWidget {
  @override
  _WebCalendarTabState createState() => _WebCalendarTabState();
}

class _WebCalendarTabState extends State<WebCalendarTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: WebCalendar(),
    );
  }
}
