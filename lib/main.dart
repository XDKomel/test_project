
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plane_chat/models/user_data.dart';
import 'package:plane_chat/screens/wrapper.dart';
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

    if (_auth.currentUser != null) {
      return MaterialApp(
        home: Home(),
      );
    }else{
      return MaterialApp(
        home: Authenticate(),
      );
    }


  }
}

