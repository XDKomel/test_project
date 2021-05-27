import 'package:flutter/material.dart';
import 'package:plane_chat/screens/authentication/authenticate.dart';
import 'package:plane_chat/services/auth.dart';
import 'package:plane_chat/shared/constants.dart' as constants;


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            '',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: constants.accentColor,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.popUntil(context, (route) => false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Authenticate()),
                  );
                },
                child: Text(
                  constants.LOG_OUT,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15
                  ),
                ))
          ],
        ),

        body: Container()
    );
  }
}
