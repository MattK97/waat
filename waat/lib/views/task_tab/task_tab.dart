import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/widgets/custom_section_title.dart';
import 'package:newappc/globals/widgets/custom_titled_container_no_border.dart';
import 'package:newappc/views/task_tab/task_container_creator/task_container_creator.dart';

import 'containers/container_carousel.dart';

final AutoDisposeStateProvider<Widget> taskTabMainWidgetProvider =
    StateProvider.autoDispose<Widget>((_) => TasksTab());

class TasksTabAnimatedSwitcher extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskTabMainWidget = ref.watch(taskTabMainWidgetProvider.state);
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
      child: taskTabMainWidget.state,
    );
  }
}

class TasksTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksTabAnimatedSwitcher = ref.watch(taskTabMainWidgetProvider.state);
    return CustomTitledContainerNoBorder(
      customSectionTitle: CustomSectionTitle(
        title: AppLocalizations.of(context).tasks,
        color: Colors.teal[400],
        disableRightIcon: false,
        leftIcon: CupertinoIcons.tag,
        rightIcon: CupertinoIcons.ellipsis,
        onPressed: () => tasksTabAnimatedSwitcher.state = TaskContainerCreator(),
      ),
      child: ContainerCarousel(),
    );
  }
}
