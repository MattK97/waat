class AnnouncementComment {
  int id;
  int announcementId;
  String creatorId;
  String content;
  String created;

  AnnouncementComment({this.id, this.announcementId, this.creatorId, this.content, this.created});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'announcement_id': this.announcementId,
      'creator_id': this.creatorId,
      'content': this.content,
      'created': this.created,
    };
  }

  factory AnnouncementComment.fromMap(Map<String, dynamic> map) {
    return AnnouncementComment(
      id: map['id'] as int,
      announcementId: map['announcement_id'] as int,
      creatorId: map['creator_id'] as String,
      content: map['content'] as String,
      created: map['created'] as String,
    );
  }
}
