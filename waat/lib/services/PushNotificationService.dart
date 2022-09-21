import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/rest/services/user_services.dart';
import 'package:newappc/screens/MainScreen.dart';

class PushNotificationService extends ChangeNotifier {
  final FirebaseMessaging _fcm;
  final Reader read;

  PushNotificationService.instance(this.read) : _fcm = FirebaseMessaging.instance {
    FirebaseMessaging.onMessage.listen(_onNewNotificationAppearsWhileForeground);
    FirebaseMessaging.onMessageOpenedApp.listen((_onNewNotificationAppearsWhileBackground));
    FirebaseMessaging.instance.onTokenRefresh.listen(_onNewTokenGenerated);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  String fcmToken;

  bool newMeetings = false;
  bool newSchedules = false;
  bool newTasks = false;
  bool newAnnouncements = false;
  bool newWorkTimes = false;
  int newMessagesCounter = 0;

  bool _shouldUpdate = false;

  bool get shouldUpdate => _shouldUpdate;
  set shouldUpdate(bool value) {
    _shouldUpdate = value;
    notifyListeners();
  }

  Future<void> checkPermission() async {
    if (Platform.isIOS) {
      _fcm.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true);
    }
  }

  void notify() {
    notifyListeners();
  }

  Future<void> _onNewTokenGenerated(String registerToken) async {
    await UserServices().checkToken(await FirebaseMessaging.instance.getToken());
  }

  Future<void> _onNewNotificationAppearsWhileForeground(RemoteMessage message) async {
    switch (message.data['topic']) {
      case "task":
        newTasks = true;
        break;
      case "announcements":
        newAnnouncements = true;
        break;
      case "schedule":
        newSchedules = true;
        break;
      case "worktime":
        newWorkTimes = true;
        break;
      case "meetigs":
        newMeetings = true;
        break;
    }
    if (message.data['topic'] == "message") {
      if (read(bottomNavigationBarIndexProvider.state).state != 2)
        read(unreadMessagesCounterProvider.state).state += 1;
    } else {
      shouldUpdate = true;
    }
    notifyListeners();
  }

  //Check if entryNotifier has any data if yes display updateButton
  void _onNewNotificationAppearsWhileBackground(RemoteMessage message) {
    switch (message.data['topic']) {
      case "task":
        newTasks = true;
        break;
      case "announcements":
        newAnnouncements = true;
        break;
      case "schedule":
        newSchedules = true;
        break;
      case "worktime":
        newWorkTimes = true;
        break;
      case "meetigs":
        newMeetings = true;
        break;
    }
    if (message.data['topic'] == "message") {
      newMessagesCounter++;
      read(bottomNavigationBarIndexProvider.state).state = 2;
    }
    notifyListeners();
  }
}
