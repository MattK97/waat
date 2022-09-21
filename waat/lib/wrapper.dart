import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/services/AuthService.dart';
import 'package:newappc/views/onboarding_flow/bridge_screen.dart';
import 'package:newappc/views/onboarding_flow/login/login_screen.dart';

class Wrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(authServiceViewModel);
    switch (user.status) {
      case Status.Uninitialized:
        return LoadingScreen();
      case Status.Authenticating:
        return LoadingScreen();
      case Status.Unauthenticated:
        return LoginScreen();
      case Status.Authenticated:
        return BridgeScreen();
    }
    return LoadingScreen();
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        height: MediaQuery.of(context).size.height / 10,
        child: Image.asset('assets/images/waat_logo_400.png'),
      )),
    );
  }
}
