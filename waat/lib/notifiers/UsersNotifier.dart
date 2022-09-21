import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/models/ColorM.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/rest/response/response_status.dart';
import 'package:newappc/screens/MainScreen.dart';

import '../main.dart';

class UsersNotifier extends ChangeNotifier {
  UsersNotifier({this.ref});

  Reader ref;
  List<User> userList;

  Future<void> fetchTeamUserList() async {
    final result = await teamServices
        .fetchTeamMembers(ref(chosenTeamProvider.state).state.teamId)
        .then((value) => value.data);
    userList = result;
    notifyListeners();
  }

  Future<void> updateUserLastSeen() async {
    // final prefs = await SharedPreferences.getInstance();
    // if (prefs.containsKey('last_seen')) {
    //   if (Jiffy(DateTime.now()).diff(DateTime.parse(prefs.getString('last_seen')), Units.MINUTE) >
    //       5) {
    //     String result = await userServices.updateLastSeen();
    //     String dateTime = dateTimeFromServerToLocale(result).toString();
    //     prefs.setString('last_seen', dateTime);
    //   }
    // } else {
    //   String result = await userServices.updateLastSeen();
    //   String dateTime = dateTimeFromServerToLocale(result).toString();
    //   prefs.setString('last_seen', dateTime);
    // }
  }

  Future<void> updateUserFirstName(String value) async {
    final result = await userServices
        .updateFirstName(value)
        .then((value) => value.code == ResponseStatus.valid);
    ;
    if (result) {
      userList
          .firstWhere((element) => element.userID == ref(authServiceViewModel).user.uid)
          .firstName = value;
      notifyListeners();
    }
  }

  Future<void> updateUserLastName(String value) async {
    final result = await userServices
        .updateLastName(value)
        .then((value) => value.code == ResponseStatus.valid);
    ;
    if (result) {
      userList
          .firstWhere((element) => element.userID == ref(authServiceViewModel).user.uid)
          .lastName = value;
      notifyListeners();
    }
  }

  Future<void> updateUserColor(ColorM colorM) async {
    final result = await userServices
        .updateColor(colorM.colorID)
        .then((value) => value.code == ResponseStatus.valid);
    ;
    if (result) {
      userList.firstWhere((element) => element.userID == ref(authServiceViewModel).user.uid).color =
          colorM.colorHex;
      notifyListeners();
    }
  }

  void addUser() {}

  void removeUser() {}

  void promoteUser() {}

  void degradeUser() {}
}
