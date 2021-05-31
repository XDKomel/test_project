import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plane_chat/custom_widgets/chat_widget.dart';
import 'package:plane_chat/models/SessionKeeper.dart';
import 'package:plane_chat/screens/home/profile.dart';
import 'package:plane_chat/shared/constants.dart' as constants;

class FlightChat extends StatefulWidget {
  final String streamId;
  FlightChat({required this.streamId});

  @override
  _FlightChatState createState() => _FlightChatState(streamId: streamId);
}

class _FlightChatState extends State<FlightChat> {
  final String streamId;
  _FlightChatState({required this.streamId});
  @override
  Widget build(BuildContext context) {
    List<String> initBanUsers = [];
    FirebaseFirestore.instance.collection('streams')
        .doc(streamId)
        .collection('blacklist')
        .doc('local').collection('users')
        .doc(SessionKeeper.user.uid)
        .collection('banned_users').get().then((value) {
       value.docs.forEach((element) {
         initBanUsers.add(element.get('uid'));
       });
    });
    List<String> initBanMessage = [];
    FirebaseFirestore.instance.collection('streams')
        .doc(streamId)
        .collection('blacklist')
        .doc('local').collection('users')
        .doc(SessionKeeper.user.uid)
        .collection('messages').get().then((value) {
      value.docs.forEach((element) {
        initBanMessage.add(element.get('uid'));
      });
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'FlightBuddy',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: constants.accentColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          TextButton.icon(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
              label: Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
              icon: Text(
                constants.PROFILE,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ))
        ],
      ),
      body: CommentField(
        streamId: streamId,
        initBanMessage: initBanMessage,
        initBanUsers: initBanUsers,
      ),
    );
  }
}
