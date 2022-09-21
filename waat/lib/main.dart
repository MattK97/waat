import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/wrapper.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pl', ''),
        const Locale('en', ''), //
        const Locale('fr', '') // English, no country code
      ],
      theme: ThemeData(
          unselectedWidgetColor: Colors.white,
          primaryColor: Colors.teal[600],
          textTheme: TextTheme(
              //App bar
              headline1: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
              //Card titles
              headline2: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
              //Card info
              headline3: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              //Card sub-info
              headline4: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
              headline5: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
              headline6: TextStyle(fontSize: 13, color: Colors.grey),
              bodyText1: TextStyle(fontSize: 13, color: Colors.white)),
          cardTheme: CardTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              elevation: 0),
          snackBarTheme: SnackBarThemeData(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
          )),
      home: Wrapper(),
    );
  }
}
