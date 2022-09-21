import 'package:newappc/globals/utils/date_utils.dart';

class AppVersion {
  final int id;
  final String os;
  final DateTime created;
  final String versionNum;
  final int versionCode;
  final String updateUrl;
  final String releaseNotes;
  final bool isCurrent;
  final bool isChatEnabled;

  AppVersion(
      {this.id,
      this.os,
      this.created,
      this.versionNum,
      this.versionCode,
      this.updateUrl,
      this.releaseNotes,
      this.isCurrent,
      this.isChatEnabled});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'os': this.os,
      'created': this.created,
      'version_num': this.versionNum,
      'version_code': this.versionCode,
      'update_url': this.updateUrl,
      'release_notes': this.releaseNotes,
      'is_current': this.isCurrent,
      'is_chat_enabled': this.isChatEnabled,
    };
  }

  factory AppVersion.fromMap(Map<String, dynamic> map) {
    final k = AppVersion(
      id: map['id'] as int,
      os: map['os'] as String,
      created: dateTimeFromServerToLocale(map['created']),
      versionNum: map['version_num'] as String,
      versionCode: map['version_code'] as int,
      updateUrl: map['update_url'] as String,
      releaseNotes: map['release_notes'] as String,
      isCurrent: map['is_current'] as bool,
      isChatEnabled: map['is_chat_enabled'] as bool,
    );
    return k;
  }
}
