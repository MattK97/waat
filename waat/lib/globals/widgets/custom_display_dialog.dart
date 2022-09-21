import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/globals/styles/radiuses.dart';
import 'package:newappc/globals/widgets/custom_image_display.dart';
import 'package:newappc/main.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/models/announcement.dart';
import 'package:newappc/models/announcement_attachment.dart';
import 'package:newappc/models/event.dart';
import 'package:newappc/models/meeting.dart';
import 'package:newappc/models/task.dart';
import 'package:newappc/screens/MainScreen.dart';

import 'custom_delete_dialog.dart';
import 'custom_display_dialog_comment_section.dart';

class CustomDisplayDialog extends ConsumerWidget {
  final Event event;
  final Color color;
  final String created;
  final String creator;
  final bool isCreator;
  final List<User> userList;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  CustomDisplayDialog({
    this.event,
    this.color,
    this.created,
    this.creator,
    this.isCreator,
    this.userList,
    this.onDelete,
    this.onEdit,
  });

  Route _createRoute(String url) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => CustomImageDisplay(
        url: url,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isModerator = ref
        .watch(usersNotifier)
        .userList
        .firstWhere((element) => element.userID == ref.watch(authServiceViewModel).user.uid)
        .isModerator;
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: borderRadius), //this right here
      child: Container(
        width: kIsWeb ? MediaQuery.of(context).size.width / 4 : MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 25, top: 25, right: 25, bottom: 15),
                        child: Text(
                          event.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if ((isCreator || isModerator) && onEdit != null)
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(CupertinoIcons.pencil, color: Colors.grey),
                            onPressed: onEdit,
                          ),
                          IconButton(
                            icon: Icon(CupertinoIcons.trash, color: Colors.grey),
                            onPressed: () async {
                              Navigator.pop(context);
                              bool shouldDelete = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  if (event is Announcement) {
                                    return CustomDeleteDialog(
                                        content: AppLocalizations.of(context)
                                            .are_you_sure_delete_announcement);
                                  } else if (event is Meeting) {
                                    return CustomDeleteDialog(
                                        content: AppLocalizations.of(context)
                                            .are_you_sure_delete_meeting);
                                  } else {
                                    return CustomDeleteDialog(
                                        content:
                                            AppLocalizations.of(context).are_you_sure_delete_task);
                                  }
                                },
                              );
                              if (shouldDelete) {
                                onDelete();
                              }
                            },
                          )
                        ],
                      ),
                    )
                  else
                    Container(),
                ],
              ),
              if (event is Meeting)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 25, right: 25, bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Jiffy((event as Meeting).start).format('dd.MM.yyyy'),
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          Jiffy((event as Meeting).start).Hm,
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Container(),
              event.info.isEmpty
                  ? Container()
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 25, right: 25, bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.info,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              if ((event is Meeting || event is Task) && userList.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 25, right: 25, bottom: 15),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context).users_included, //TODO ADD LOCALIZATION
                          style: TextStyle(color: color, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: userList.length,
                          itemBuilder: (context, index) {
                            User user = userList[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 2),
                              child: Text(
                                user.firstName,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }),
                    ],
                  ),
                )
              else
                Container(),
              event is Announcement
                  ? Column(
                      children: [
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: (event as Announcement).attachmentList.length,
                            itemBuilder: (context, index) {
                              final AnnouncementAttachment attachment =
                                  (event as Announcement).attachmentList[index];
                              return ListTile(
                                onTap: () {
                                  Navigator.of(context).push(_createRoute(attachment.url));
                                },
                                leading: Icon(CupertinoIcons.paperclip),
                                title: Text(attachment.name, style: TextStyle(color: Colors.grey)),
                              );
                            }),
                        Padding(
                          padding: EdgeInsets.only(right: 20, bottom: 20),
                          child: Align(
                            alignment: FractionalOffset.bottomRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  creator,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: color),
                                ),
                                Text(
                                  created,
                                  style: TextStyle(color: color),
                                )
                              ],
                            ),
                          ),
                        ),
                        CustomDisplayDialogCommentSection(event: event)
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
