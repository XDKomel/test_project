import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plane_chat/screens/authentication/authenticate.dart';
import 'package:plane_chat/screens/authentication/sign_in.dart';
import 'package:plane_chat/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:plane_chat/services/database.dart';
import 'package:plane_chat/shared/constants.dart' as constants;


class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          title: Text('FlightBuddy', style: TextStyle(color: Colors.white),),
          backgroundColor: constants.accentColor,
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Authenticate()),
                  );
                },
                icon: Icon(Icons.person, color: Colors.white,),
                label: Text('Log out')
            )
          ],
      ),
    );
  }
}
