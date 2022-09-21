import 'package:flutter/cupertino.dart';
import 'package:newappc/models/Team.dart';
import 'package:newappc/models/announcement.dart';
import 'package:newappc/models/announcement_comment.dart';
import 'package:newappc/rest/response/response_status.dart';
import 'package:newappc/screens/MainScreen.dart';

class AnnouncementsNotifier extends ChangeNotifier {
  AnnouncementsNotifier(this.team);

  List<Announcement> announcementList;
  Team team;

  Future<void> fetchAnnouncements(int month) async {
    final result = await announcementServices
        .fetchAnnouncements(team.teamId, month)
        .then((value) => value.data);
    announcementList = result;
    notifyListeners();
  }

  Future<bool> addAnnouncement(Announcement announcement) async {
    int announcementID = await announcementServices
        .createAnnouncement(team.teamId, announcement)
        .then((value) => value.data['object_id']);
    if (announcementList.firstWhere((element) => element.announcementID == announcementID,
                orElse: () => null) !=
            null &&
        announcementID != null) {
      announcementList
          .removeWhere((element) => element.announcementID == announcement.announcementID);
      announcementList.add(announcement);
      notifyListeners();
      return true;
    } else if (announcementList.firstWhere((element) => element.announcementID == announcementID,
                orElse: () => null) ==
            null &&
        announcementID != null) {
      announcement.announcementID = announcementID;
      announcementList.add(announcement);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<int> addAnnouncementComment(
      Announcement announcement, AnnouncementComment announcementComment) async {
    final result = await announcementServices
        .createAnnouncementComment(team.teamId, announcementComment)
        .then((value) => value.data['object_id']);
    return result;
  }

  Future<bool> deleteAnnouncementComment(AnnouncementComment announcementComment) async {
    final result = await announcementServices
        .deleteAnnouncementComment(team.teamId, announcementComment)
        .then((value) => value.code == ResponseStatus.valid);
    return result;
  }

  Future<bool> updateAnnouncementComment(AnnouncementComment announcementComment) async {
    final result = await announcementServices
        .updateAnnouncementComment(team.teamId, announcementComment)
        .then((value) => value.code == ResponseStatus.valid);
    ;
    return result;
  }

  Future<bool> updateAnnouncement(Announcement replacingAnnouncement) async {
    int announcementID = await announcementServices
        .updateAnnouncement(team.teamId, replacingAnnouncement)
        .then((value) => value.data['object_id']);
    ;
    if (announcementID != null) {
      final announcementToBeReplaced = announcementList
          .firstWhere((element) => element.announcementID == replacingAnnouncement.announcementID);
      announcementList.remove(announcementToBeReplaced);
      announcementList.add(replacingAnnouncement);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updateAnnouncementOrder(List<Announcement> orderedAnnouncementList) async {
    List<Map<String, int>> list = [];
    int i = 0;
    orderedAnnouncementList.forEach((element) {
      Map<String, int> announcementOrderMap = {};
      announcementOrderMap['id'] = element.announcementID;
      announcementOrderMap['order'] = i;
      list.add(announcementOrderMap);
      i++;
    });

    final result = await announcementServices
        .updateAnnouncementOrder(team.teamId, list)
        .then((value) => value.code == ResponseStatus.valid);

    if (result) {
      announcementList = orderedAnnouncementList;
      announcementList.forEach((element) {
        element.order = announcementList.indexOf(element);
      });
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void removeAnnouncement(Announcement announcement) async {
    final result = await announcementServices
        .deleteAnnouncement(team.teamId, announcement)
        .then((value) => value.code == ResponseStatus.valid);
    if (result) {
      announcementList.remove(announcement);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
