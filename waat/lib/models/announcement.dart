import 'package:newappc/globals/utils/date_utils.dart';
import 'package:newappc/models/announcement_attachment.dart';

import 'announcement_comment.dart';
import 'event.dart';

class Announcement extends Event {
  int announcementID;
  String creatorID;
  String name;
  String info;
  String teamId;
  int colorID;
  String color;
  DateTime created;
  DateTime open;
  bool confirmation;
  int order;
  List<AnnouncementAttachment> attachmentList;
  List<AnnouncementComment> commentList;

  Announcement(
      {this.announcementID,
      this.name,
      this.info,
      this.teamId,
      this.created,
      this.open,
      this.creatorID,
      this.colorID,
      this.order,
      this.color,
      this.confirmation,
      this.attachmentList,
      this.commentList});

  Announcement.fromJson(Map<String, dynamic> json) {
    announcementID = json['announcement_id'];
    creatorID = json['creator_id'];
    name = json['name'];
    info = json['info'];
    created = dateTimeFromServerToLocale(json['created']);
    open = dateTimeFromServerToLocale(json['open']);
    color = json['color'];
    confirmation = json['confirmation'];
    colorID = json['color_id'];
    order = json['order'];
    attachmentList = json['attachments']
        .map<AnnouncementAttachment>((e) => AnnouncementAttachment.fromMap(e))
        .toList();
    commentList =
        json['comments'].map<AnnouncementComment>((e) => AnnouncementComment.fromMap(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['announcement_id'] = this.announcementID;
    data['creator_id'] = this.creatorID;
    data['name'] = this.name;
    data['info'] = this.info;
    data['team_id'] = this.teamId;
    data['created'] = this.created?.toUtc().toString();
    data['open'] = this.open?.toUtc().toString();
    data['color_id'] = this.colorID;
    data['confirmation'] = this.confirmation;
    data['order'] = this.order;
    data['attachments'] = this.attachmentList.map((e) => e.toMap()).toList();
    return data;
  }
}
