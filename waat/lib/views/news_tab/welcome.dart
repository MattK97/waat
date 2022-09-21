import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newappc/main.dart';
import 'package:newappc/screens/MainScreen.dart';

class Welcome extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersN = ref.watch(usersNotifier);
    final authS = ref.watch(authServiceViewModel);
    final firstName =
        usersN.userList.firstWhere((element) => element.userID == authS.user.uid).firstName;
    return Padding(
      padding: EdgeInsets.all(25),
      child: Container(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).hello,
                  style: TextStyle(
                      fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 36),
                ),
                Text(firstName,
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontWeight: FontWeight.w500, fontSize: 24)),
              ],
            ),
            Expanded(
              flex: 2,
              child: SizedBox(
                width: 1,
              ),
            ),
            Neumorphic(
              style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                  depth: 5,
                  intensity: 1,
                  lightSource: LightSource.topLeft,
                  color: Colors.white),
              child: Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${Jiffy().MMM}',
                          style: TextStyle(
                              fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 20)),
                      Text('${Jiffy().format('dd')}',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.teal[400])),
                      Text('${Jiffy().year}',
                          style:
                              TextStyle(fontFamily: 'Montserrat', fontSize: 16, color: Colors.grey))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
