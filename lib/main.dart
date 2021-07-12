import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plane_chat/intro_screen.dart';

import 'package:plane_chat/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/authentication/authenticate.dart';
import 'screens/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();

  print(preferences.toString());
  int counter = preferences.getInt("splash") ?? 0;
  bool isSplash = counter == 0;

  runApp(MyApp(isSplash, preferences));
}

class MyApp extends StatelessWidget {
  SharedPreferences preferences;
  bool isSplashes;

  MyApp(this.isSplashes, this.preferences);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: _auth.currentUser != null
            ? MaterialApp(
                home: Builder(
                builder: (context) => isSplashes
                    ? IntroScreen(
                        onFinish: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                            return Home();
                          }));
                        },
                        preferences: preferences,
                      )
                    : Home(),

                //,
              ))
            : MaterialApp(
                home: Builder(
                builder: (context) => isSplashes
                    ? IntroScreen(
                        onFinish: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                            return Authenticate();
                          }));
                        },
                        preferences: preferences,
                      )
                    : Authenticate(),
                //Authenticate(),
              )));
  }
}
