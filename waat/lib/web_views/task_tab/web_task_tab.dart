import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'web_containers.dart';

final AutoDisposeStateProvider<Widget> webTaskTabMainWidgetProvider =
    StateProvider.autoDispose((ref) => WebTaskTab());

class WebTaskAnimatedSwitcher extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webTaskTabMainWidget = ref.watch(webTaskTabMainWidgetProvider.state);
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
      child: webTaskTabMainWidget.state,
    );
  }
}

class WebTaskTab extends StatefulWidget {
  @override
  _WebTaskTab createState() => _WebTaskTab();
}

class _WebTaskTab extends State<WebTaskTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: WebContainers(),
    );
  }
}
