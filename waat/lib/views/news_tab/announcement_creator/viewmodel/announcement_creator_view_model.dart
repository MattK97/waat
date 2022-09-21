import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newappc/main.dart';
import 'package:newappc/models/ColorM.dart';
import 'package:newappc/models/announcement.dart';
import 'package:newappc/models/announcement_attachment.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/news_tab/news_tab.dart';

class AnnouncementCreatorViewModel extends ChangeNotifier {
  AnnouncementCreatorViewModel({this.ref});

  Reader ref;

  void operateOnAnnouncement(
          {Announcement chosenAnnouncement,
          List<XFile> listOfAttachmentsFromDevice,
          List<AnnouncementAttachment> listOfAttachmentsFromWeb,
          String title,
          String info,
          ColorM color}) =>
      chosenAnnouncement == null
          ? _createNewAnnouncement(
              title: title,
              info: info,
              color: color,
              listOfAttachmentsFromDevice: listOfAttachmentsFromDevice)
          : _updateAnnouncement(
              chosenAnnouncement: chosenAnnouncement,
              title: title,
              info: info,
              color: color,
              listOfAttachmentsFromDevice: listOfAttachmentsFromDevice,
              listOfAttachmentsFromWeb: listOfAttachmentsFromWeb,
            );

  Future<void> _createNewAnnouncement(
      {String title, String info, ColorM color, List<XFile> listOfAttachmentsFromDevice}) async {
    List<AnnouncementAttachment> attachments =
        await Future.wait(listOfAttachmentsFromDevice.map((e) async {
      File file = File(e.path);
      TaskSnapshot snap = await firebase_storage.FirebaseStorage.instance
          .ref('announcement-attachments/${e.name}')
          .putFile(file);
      String url = await snap.ref.getDownloadURL();
      return AnnouncementAttachment(name: e.name, url: url);
    }).toList());

    Announcement announcement = Announcement(
        announcementID: null,
        name: title,
        info: info,
        teamId: ref(chosenTeamProvider.state).state.teamId,
        creatorID: ref(authServiceViewModel).user.uid,
        open: DateTime.now(),
        colorID: color.colorID,
        color: color.colorHex,
        attachmentList: attachments,
        commentList: [],
        order: ref(announcementsNotifier).announcementList.isEmpty
            ? 0
            : ref(announcementsNotifier)
                    .announcementList
                    .map((e) => e.order)
                    .toList()
                    .reduce((curr, next) => curr < next ? curr : next) -
                1);
    if (await ref(announcementsNotifier).addAnnouncement(announcement)) {
      ref(newsTabMainWidgetProvider.state).state = NewsTab();
    }
    ;
  }

  Future<void> _updateAnnouncement({
    Announcement chosenAnnouncement,
    String title,
    String info,
    ColorM color,
    List<XFile> listOfAttachmentsFromDevice,
    List<AnnouncementAttachment> listOfAttachmentsFromWeb,
  }) async {
    List<AnnouncementAttachment> attachments =
        await Future.wait(listOfAttachmentsFromDevice.map((e) async {
      File file = File(e.path);
      TaskSnapshot snap = await firebase_storage.FirebaseStorage.instance
          .ref('announcement-attachments/${e.name}')
          .putFile(file);
      String url = await snap.ref.getDownloadURL();
      return AnnouncementAttachment(name: e.name, url: url);
    }).toList());

    attachments.addAll(listOfAttachmentsFromWeb);

    Announcement announcement = Announcement(
        announcementID: chosenAnnouncement.announcementID,
        name: title,
        info: info,
        teamId: chosenAnnouncement.teamId,
        creatorID: chosenAnnouncement.creatorID,
        open: chosenAnnouncement.open,
        attachmentList: attachments,
        colorID: color.colorID,
        color: color.colorHex,
        commentList: chosenAnnouncement.commentList,
        order: chosenAnnouncement.order);
    if (await ref(announcementsNotifier).updateAnnouncement(announcement)) {
      ref(newsTabMainWidgetProvider.state).state = NewsTab();
    }
  }
}
