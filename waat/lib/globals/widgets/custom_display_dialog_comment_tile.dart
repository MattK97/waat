import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/models/announcement_comment.dart';
import 'package:newappc/views/news_tab/announcements/announcement_commenter_icon.dart';

class CustomDisplayDialogCommentTile extends StatefulWidget {
  final Function(AnnouncementComment announcementComment, BuildContext context)
      notifyParentOnDelete;
  final Function(AnnouncementComment announcementComment, BuildContext context) notifyParentOnEdit;
  final Function(AnnouncementComment announcementComment, bool isCommenting)
      notifyParentAboutInputState;
  final AnnouncementComment comment;
  final User creator;
  final bool isCreator;

  const CustomDisplayDialogCommentTile(
      {Key key,
      this.comment,
      this.creator,
      this.isCreator,
      this.notifyParentOnDelete,
      this.notifyParentOnEdit,
      this.notifyParentAboutInputState})
      : super(key: key);

  @override
  _CustomDisplayDialogCommentTileState createState() => _CustomDisplayDialogCommentTileState();
}

class _CustomDisplayDialogCommentTileState extends State<CustomDisplayDialogCommentTile> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),

      // The end action pane is the one at the right or the bottom side.
      endActionPane: widget.isCreator
          ? ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  // An action can be bigger than the others.
                  flex: 2,
                  onPressed: (context) {
                    widget.notifyParentAboutInputState(widget.comment, true);
                  },
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: CupertinoIcons.pen,
                  label: 'Edit',
                ),
                SlidableAction(
                  onPressed: (context) {
                    widget.notifyParentOnDelete(widget.comment, context);
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: CupertinoIcons.trash,
                  label: 'Delete',
                ),
              ],
            )
          : null,
      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: ListTile(
          leading: AnnouncementCommenterIcon('Matt', "fcba03"),
          title: Container(
            color: Colors.grey[50],
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.creator.firstName,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.comment.content,
                      style: TextStyle(fontSize: 14),
                    )),
                Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      widget.comment.created,
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ))
              ],
            ),
          )),
    );
  }
}
