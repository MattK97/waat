import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/widgets/custom_section_title.dart';
import 'package:newappc/globals/widgets/custom_titled_container_no_border.dart';
import 'package:newappc/views/news_tab/announcement_creator/announcement_creator.dart';
import 'package:newappc/web_views/task_tab/web_container_list.dart';
import 'package:newappc/web_views/task_tab/web_task_tab.dart';

class WebContainers extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webTaskTabMainWidget = ref.watch(webTaskTabMainWidgetProvider.state);
    return CustomTitledContainerNoBorder(
      customSectionTitle: CustomSectionTitle(
        title: 'Tasks', //TODO localization
        disableRightIcon: false,
        leftIcon: CupertinoIcons.doc,
        rightIcon: CupertinoIcons.add,
        color: Colors.teal[400],
        onPressed: () {
          webTaskTabMainWidget.state = AnnouncementCreator();
        },
      ),
      child: WebContainerList(),
    );
  }
}
