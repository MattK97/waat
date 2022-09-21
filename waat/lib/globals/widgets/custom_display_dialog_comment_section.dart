import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/models/announcement.dart';
import 'package:newappc/models/announcement_comment.dart';
import 'package:newappc/models/event.dart';
import 'package:newappc/screens/MainScreen.dart';

import '../../main.dart';
import 'custom_display_dialog_comment_tile.dart';
import 'custom_display_dialog_input.dart';

class CustomDisplayDialogCommentSection extends ConsumerStatefulWidget {
  final Event event;

  CustomDisplayDialogCommentSection({this.event});

  @override
  _CustomDisplayDialogCommentSectionState createState() =>
      _CustomDisplayDialogCommentSectionState();
}

class _CustomDisplayDialogCommentSectionState
    extends ConsumerState<CustomDisplayDialogCommentSection> {
  bool _isSendingComment = false;
  bool _isCommenting = false;
  AnnouncementComment _tempComment;

  Future<void> _addNewComment(AnnouncementComment announcementComment, BuildContext context) async {
    setState(() {
      _isSendingComment = true;
    });
    announcementComment.announcementId = (widget.event as Announcement).announcementID;
    final result = await ref
        .read(announcementsNotifier)
        .addAnnouncementComment(widget.event, announcementComment);
    setState(() {
      if (result != null) {
        announcementComment.id = result;
        (widget.event as Announcement).commentList.add(announcementComment);
      }
      _isSendingComment = false;
    });
  }

  Future<void> _deleteComment(AnnouncementComment announcementComment, BuildContext context) async {
    await ref.read(announcementsNotifier).deleteAnnouncementComment(announcementComment);
    setState(() {
      (widget.event as Announcement).commentList.remove(announcementComment);
    });
  }

  Future<void> _editComment(AnnouncementComment announcementComment, BuildContext context) async {
    setState(() {
      _isSendingComment = true;
    });
    announcementComment.announcementId = (widget.event as Announcement).announcementID;
    final result =
        await ref.read(announcementsNotifier).updateAnnouncementComment(announcementComment);
    setState(() {
      if (result) (widget.event as Announcement).commentList.add(announcementComment);
      _isSendingComment = false;
      _tempComment = null;
    });
  }

  void _changeIsCommentingState(AnnouncementComment announcementComment, bool isCommenting) {
    setState(() {
      (widget.event as Announcement).commentList.remove(announcementComment);
      this._isCommenting = isCommenting;
      _tempComment = announcementComment;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      User currentUser = ref
          .watch(usersNotifier)
          .userList
          .firstWhere((element) => element.userID == ref.watch(authServiceViewModel).user.uid);
      return Column(
        children: [
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: (widget.event as Announcement).commentList.length,
              itemBuilder: (context, index) {
                AnnouncementComment comment = (widget.event as Announcement).commentList[index];
                User creator = ref
                    .watch(usersNotifier)
                    .userList
                    .firstWhere((element) => element.userID == comment.creatorId);

                bool isCreator = currentUser.userID == creator.userID;
                return CustomDisplayDialogCommentTile(
                  comment: comment,
                  creator: creator,
                  isCreator: isCreator,
                  notifyParentOnDelete: _deleteComment,
                  notifyParentOnEdit: _editComment,
                  notifyParentAboutInputState: _changeIsCommentingState,
                );
              }),
          SizedBox(
            height: 16,
          ),
          _isCommenting ? Container() : Divider(),
          CustomDisplayDialogInput(
            user: currentUser,
            notifyParentAboutNewComment: _addNewComment,
            notifyParentAboutCommentUpdate: _editComment,
            notifyParentAboutInputState: _changeIsCommentingState,
            isSending: _isSendingComment,
            isCommenting: _isCommenting,
            announcementComment: _tempComment,
          )
        ],
      );
    });
  }
}
