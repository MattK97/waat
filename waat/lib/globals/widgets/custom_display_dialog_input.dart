import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newappc/globals/styles/radiuses.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/models/announcement_comment.dart';

class CustomDisplayDialogInput extends StatefulWidget {
  final Function(AnnouncementComment announcementComment, BuildContext context)
      notifyParentAboutNewComment;
  final Function(AnnouncementComment announcementComment, BuildContext context)
      notifyParentAboutCommentUpdate;
  final Function(AnnouncementComment announcementComment, bool isCommenting)
      notifyParentAboutInputState;

  final AnnouncementComment announcementComment;
  final bool isSending;
  final bool isCommenting;
  final User user;

  CustomDisplayDialogInput(
      {Key key,
      this.notifyParentAboutNewComment,
      this.isSending,
      this.user,
      this.announcementComment,
      this.notifyParentAboutCommentUpdate,
      this.isCommenting,
      this.notifyParentAboutInputState})
      : super(key: key);

  @override
  _CustomDisplayDialogInputState createState() => _CustomDisplayDialogInputState();
}

class _CustomDisplayDialogInputState extends State<CustomDisplayDialogInput> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    textEditingController.text =
        widget.announcementComment == null ? '' : widget.announcementComment.content;
    return widget.isCommenting != null && widget.isCommenting
        ? Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 32),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Colors.grey, // set border color
                    width: 1.0), // set border width
                borderRadius: borderRadius, // set rounded corner radius
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: textEditingController,
                        maxLines: null,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: InputBorder.none,
                          hintText: "Add comment",
                        )),
                    flex: 7,
                  ),
                  Expanded(
                    child: IconButton(
                        disabledColor: Colors.grey,
                        icon: Icon(
                          CupertinoIcons.arrow_up_circle,
                        ),
                        onPressed: widget.isSending
                            ? null
                            : () async {
                                if (widget.announcementComment != null) {
                                  widget.announcementComment.content = textEditingController.text;
                                  widget.notifyParentAboutCommentUpdate(
                                      widget.announcementComment, context);
                                } else {
                                  AnnouncementComment announcementComment = AnnouncementComment(
                                      content: textEditingController.text,
                                      creatorId: widget.user.userID,
                                      created: DateTime.now().toUtc().toString());
                                  widget.notifyParentAboutNewComment(announcementComment, context);
                                }
                              }),
                    flex: 1,
                  )
                ],
              ),
            ),
          )
        : ListTile(
            onTap: () => setState(() {
              widget.notifyParentAboutInputState(null, true);
            }),
            leading: Icon(CupertinoIcons.add),
            title: Text('Add comment', style: TextStyle(color: Colors.grey)),
          );
    ;
  }
}
