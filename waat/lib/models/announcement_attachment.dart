class AnnouncementAttachment {
  final int id;
  final String name;
  final String url;
  final String created;
  AnnouncementAttachment({this.id, this.name, this.url, this.created});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'url': this.url,
      'created': this.created,
    };
  }

  factory AnnouncementAttachment.fromMap(Map<String, dynamic> map) {
    return AnnouncementAttachment(
      id: map['id'] as int,
      name: map['name'] as String,
      url: map['url'] as String,
      created: map['created'] as String,
    );
  }
}
