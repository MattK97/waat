import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/views/news_tab/announcements/announcements.dart';

final AutoDisposeStateProvider<Widget> webPinboardTabMainWidgetProvider =
    StateProvider.autoDispose((ref) => WebPinboardTab());

class WebPinboardAnimatedSwitcher extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webPinboardTabMainWidget = ref.watch(webPinboardTabMainWidgetProvider.state);
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
      child: webPinboardTabMainWidget.state,
    );
  }
}

class WebPinboardTab extends StatefulWidget {
  @override
  _WebPinboardTabState createState() => _WebPinboardTabState();
}

class _WebPinboardTabState extends State<WebPinboardTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Announcements(),
    );
  }
}
