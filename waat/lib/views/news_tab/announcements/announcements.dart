import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/widgets/custom_section_title.dart';
import 'package:newappc/globals/widgets/custom_titled_container_no_border.dart';
import 'package:newappc/screens/MainScreen.dart';

import '../announcement_creator/announcement_creator.dart';
import '../news_tab.dart';
import 'announcement_list.dart';

class Announcements extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsTabMainWidget = ref.watch(newsTabMainWidgetProvider.state);
    return CustomTitledContainerNoBorder(
      customSectionTitle: CustomSectionTitle(
        title: AppLocalizations.of(context).pinboard, //TODO localization
        disableRightIcon: false,
        leftIcon: CupertinoIcons.doc,
        rightIcon: CupertinoIcons.add,
        color: Colors.teal[400],
        onPressed: () {
          print(ref.watch(announcementsNotifier).announcementList);
          newsTabMainWidget.state = AnnouncementCreator();
        },
      ),
      child: AnnouncementList(),
    );
  }
}
