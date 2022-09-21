import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/rest/response/response_status.dart';
import 'package:newappc/screens/MainScreen.dart';

class TeamSettingsViewModel extends ChangeNotifier {
  TeamSettingsViewModel({this.ref});

  Reader ref;

  Future<bool> degradeUser(String teamID, String userID) async {
    bool response = await userServices
        .degradeUser(teamID, userID)
        .then((value) => value.code == ResponseStatus.valid);
    ;
    if (response) {
      ref(usersNotifier).userList.firstWhere((element) => element.userID == userID).isModerator =
          false;
      notifyListeners();
      return response;
    } else {
      return response;
    }
  }

  Future<bool> promoteUser(String teamID, String userID) async {
    bool response = await userServices
        .promoteUser(teamID, userID)
        .then((value) => value.code == ResponseStatus.valid);
    ;
    if (response) {
      ref(usersNotifier).userList.firstWhere((element) => element.userID == userID).isModerator =
          true;
      notifyListeners();
      return response;
    } else {
      return response;
    }
  }
}
