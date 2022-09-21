import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:newappc/screens/MainScreen.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthService extends ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  Status _status = Status.Uninitialized;
  String fcmToken;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  AuthService.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Status get status => _status;

  User get user => _user;

  Future<void> _onAuthStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else if (_status != Status.Authenticated) {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<bool> signUp(String email, String password) async {
    try {
      UserCredential credential =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print(credential);
      if (credential != null && credential.user != null) {
        _user = credential.user;
        _status = Status.Authenticated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await userServices.checkToken(await FirebaseMessaging.instance.getToken());
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();

    _status = Status.Unauthenticated;
    notifyListeners();

    return Future.delayed(Duration.zero);
  }

  Future<bool> deleteAccount() async {
    try {
      await userServices.deleteAccount();
      await _auth.currentUser.delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
