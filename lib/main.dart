import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plane_chat/models/UserData.dart';
import 'package:plane_chat/services/auth.dart';
import 'package:provider/provider.dart';

import 'screens/authentication/authenticate.dart';
import 'screens/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final FirebaseAuth _auth = FirebaseAuth.instance;
    return GestureDetector(
        onTap: () {

          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }

        },
        child: _auth.currentUser != null? MaterialApp(
    home: Home(),
    ) : MaterialApp(
    home: Authenticate(),
    )
    );
  }
}



