import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/additional_widgets/hex_color.dart';
import 'package:newappc/globals/widgets/custom_display_dialog.dart';
import 'package:newappc/models/announcement.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/news_tab/announcement_creator/announcement_creator.dart';

import '../news_tab.dart';
import 'announcement_card.dart';

class AnnouncementList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsN = ref.watch(announcementsNotifier);
    return announcementsN.announcementList.isEmpty
        ? Container(
            margin: EdgeInsets.only(top: 32, bottom: 32),
            height: MediaQuery.of(context).size.height / 8,
            child: Opacity(
              opacity: 0.7,
              child: Image.asset('assets/images/note.png'),
            ),
          )
        : Announcements(
            announcements: announcementsN.announcementList,
          );
  }
}

class Announcements extends StatefulWidget {
  final List<Announcement> announcements;

  Announcements({this.announcements});

  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  List<Announcement> announcementList;
  List<Announcement> tmpList;

  int pos;
  int variableSet = 0;
  ScrollController _scrollController;
  double width;
  double height;

  @override
  void initState() {
    super.initState();
    _calcTempList();
  }

  void _calcTempList() {
    announcementList = widget.announcements;
    announcementList?.sort((a, b) => a.order.compareTo(b.order));
    tmpList = [...announcementList];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: announcementList.length > 2
          ? MediaQuery.of(context).size.height / 1.8
          : MediaQuery.of(context).size.height / 4,
      child: Consumer(
        builder: (context, ref, child) {
          final announcementN = ref.watch(announcementsNotifier);
          final usersN = ref.watch(usersNotifier);
          final authVM = ref.watch(authServiceViewModel);
          final newsTabMainWidget = ref.watch(newsTabMainWidgetProvider.state);
          _calcTempList();
          return DragAndDropGridView.horizontal(
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: announcementList.length > 2 ? 2 : 1,
              childAspectRatio: announcementList.length > 2 ? (3 / 4.5) : (1),
            ),
            itemBuilder: (context, index) {
              final Announcement announcement = announcementList[index];
              return Opacity(
                  opacity: pos != null
                      ? pos == index
                          ? 0.6
                          : 1
                      : 1,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => CustomDisplayDialog(
                              event: announcement,
                              color: HexColor(announcement.color),
                              creator: usersN.userList
                                  .firstWhere((element) => element.userID == announcement.creatorID)
                                  .firstName,
                              created: Jiffy(announcement.created).yMMMd,
                              isCreator: authVM.user.uid == announcement.creatorID,
                              onDelete: () => announcementN.removeAnnouncement(announcement),
                              onEdit: () {
                                Navigator.pop(context);
                                newsTabMainWidget.state = AnnouncementCreator(
                                  chosenAnnouncement: announcement,
                                );
                              }));
                    },
                    child: LayoutBuilder(builder: (context, costrains) {
                      if (variableSet == 0) {
                        height = costrains.maxHeight;
                        width = costrains.maxWidth;
                        variableSet++;
                      }
                      return GridTile(
                          key: index == 4 ? Key("12") : null,
                          child: AnnouncementCard(
                            hexColor: announcement.color,
                            height: height,
                            width: width,
                            announcementTitle: announcement.name,
                            announcementInfo: announcement.info,
                            announcementCreationDateTime: announcement.created,
                            announcementCreator: usersN.userList
                                .firstWhere((element) => element.userID == announcement.creatorID)
                                .firstName,
                          ));
                    }),
                  ));
            },
            itemCount: announcementList.length,
            onWillAccept: (oldIndex, newIndex) {
              announcementList = [...tmpList];
              int indexOfFirstItem = announcementList.indexOf(announcementList[oldIndex]);
              int indexOfSecondItem = announcementList.indexOf(announcementList[newIndex]);

              if (indexOfFirstItem > indexOfSecondItem) {
                for (int i = announcementList.indexOf(announcementList[oldIndex]);
                    i > announcementList.indexOf(announcementList[newIndex]);
                    i--) {
                  var tmp = announcementList[i - 1];
                  announcementList[i - 1] = announcementList[i];
                  announcementList[i] = tmp;
                }
              } else {
                for (int i = announcementList.indexOf(announcementList[oldIndex]);
                    i < announcementList.indexOf(announcementList[newIndex]);
                    i++) {
                  var tmp = announcementList[i + 1];
                  announcementList[i + 1] = announcementList[i];
                  announcementList[i] = tmp;
                }
              }
              setState(
                () {
                  pos = newIndex;
                },
              );
              return true;
            },
            onReorder: (oldIndex, newIndex) {
              announcementList = [...tmpList];

              int indexOfFirstItem = announcementList.indexOf(announcementList[oldIndex]);
              int indexOfSecondItem = announcementList.indexOf(announcementList[newIndex]);

              if (indexOfFirstItem > indexOfSecondItem) {
                for (int i = announcementList.indexOf(announcementList[oldIndex]);
                    i > announcementList.indexOf(announcementList[newIndex]);
                    i--) {
                  var tmp = announcementList[i - 1];
                  announcementList[i - 1] = announcementList[i];
                  announcementList[i] = tmp;
                }
              } else {
                for (int i = announcementList.indexOf(announcementList[oldIndex]);
                    i < announcementList.indexOf(announcementList[newIndex]);
                    i++) {
                  var tmp = announcementList[i + 1];
                  announcementList[i + 1] = announcementList[i];
                  announcementList[i] = tmp;
                }
              }
              tmpList = [...announcementList];
              setState(
                () {
                  pos = null;
                },
              );
              final reorderedAnnouncementList = [];
              announcementN.updateAnnouncementOrder(announcementList);
            },
          );
        },
      ),
    );
  }
}
