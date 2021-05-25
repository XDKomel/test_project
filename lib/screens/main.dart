import 'package:custom_navigator/custom_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plane_chat/models/UserData.dart';
import 'package:plane_chat/screens/wrapper.dart';
import 'package:plane_chat/services/auth.dart';
import 'package:provider/provider.dart';

import 'authentication/authenticate.dart';
import 'home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    //final user = Provider.of<User>(context);
    //return
      // MultiProvider(
      // providers: [
      //   Provider<AuthService>(
      //     create: (_) => AuthService(),
      //   ),
      //   StreamProvider(
      //     create: (context) => context.read<AuthService>().authState, initialData: null,
      //   )
      // ],

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
    //   return
    //   StreamBuilder<UserData?>(
    //     stream: AuthService().user,
    //     builder: (BuildContext context, snapshot) {
    //       if (snapshot.hasData) {
    //         return Home();
    //       }
    //
    //       return Authenticate();
    //     },
    // );


  }
}



