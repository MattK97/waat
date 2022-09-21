import 'package:jiffy/jiffy.dart';
import 'package:newappc/globals/utils/date_utils.dart';

class User {
  String userID;
  String firstName;
  String lastName;
  String color;
  bool isModerator;
  String lastSeen;
  bool isOnline = false;

  User({this.userID, this.firstName, this.lastName, this.color, this.isModerator, this.lastSeen});

  String _calculateLastTimeSeen(String lastSeenTimestamp) {
    if (lastSeenTimestamp == null || lastSeenTimestamp == 'None') {
      isOnline = false;
      return 'Offline';
    } else if (Jiffy(DateTime.now())
            .diff(dateTimeFromServerToLocale(lastSeenTimestamp), Units.MINUTE) >
        5) {
      isOnline = false;
      return Jiffy(dateTimeFromServerToLocale(lastSeenTimestamp)).Hm;
    } else {
      isOnline = true;
      return 'Online';
    }
  }

  User.fromJson(Map<String, dynamic> json) {
    userID = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    color = json['color'];
    isModerator = json['moderator'];
    lastSeen = json['last_seen'] == null || json['last_seen'] == 'None'
        ? 'Offline'
        : _calculateLastTimeSeen(json['last_seen']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userID;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['color'] = this.color;
    data['moderator'] = this.isModerator;
    return data;
  }
}
