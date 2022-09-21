import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/models/Team.dart';
import 'package:newappc/rest/response/list_response.dart';
import 'package:newappc/rest/response/single_response.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/onboarding_flow/account_onboarding/account_onboarding_screen.dart';
import 'package:newappc/views/onboarding_flow/role_onboarding/role_onboarding_screen.dart';

final basicInfoProvider = FutureProvider.autoDispose((ref) async {
  return Future.wait([
    userServices.checkExistence(),
    userServices.fetchUserTeams(),
  ]);
});

class BridgeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<dynamic>> basicInfo = ref.watch(basicInfoProvider);
    return basicInfo.when(
      loading: () => Scaffold(
          body: Center(
              child: CircularProgressIndicator(
        color: Colors.teal[400],
      ))),
      error: (error, stack) {
        print(error);
        return Center(child: const Text('An error occurred while fetching initial user data'));
      },
      data: (snapshot) {
        final bool userExist = (snapshot[0] as SingleResponse<Map<String, dynamic>>).data['exist'];

        if (!userExist) {
          return AccountOnboardingScreen();
        }
        final List<Team> teamList = (snapshot[1] as ListResponse<Team>).data;

        if (teamList == null || teamList.isEmpty) {
          return RoleOnboardingScreen();
        }
        return MainScreen();
      },
    );
  }
}
