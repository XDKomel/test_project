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
  List<String> initBanUsers = [];
  List<String> initBanMessage = [];
  int num_of_people=0;

  _FlightChatState({required this.streamId});
  void queryBanUsers() async {
    FirebaseFirestore.instance.collection('streams')
        .doc(streamId)
        .collection('blacklist')
        .doc('local').collection('users')
        .doc(SessionKeeper.user.uid)
        .collection('banned_users').snapshots().listen((snapshot) {
      snapshot.docs.forEach((element) {
        initBanUsers.add(element.get('uid'));
      });
    });
  }
  void queryBanMessages() async {
    FirebaseFirestore.instance.collection('streams')
        .doc(streamId)
        .collection('blacklist')
        .doc('local').collection('users')
        .doc(SessionKeeper.user.uid)
        .collection('messages').snapshots().listen((snapshot) {
      snapshot.docs.forEach((element) {
        initBanMessage.add(element.get('uid'));
      });
    });
  }
  void queryNumOfPeople() async {
    FirebaseFirestore.instance.collection('flights')
        .doc(streamId).snapshots().listen((snapshot) {
          num_of_people = snapshot.data()!['peopleInChat'];
          setState(() {

          });
        });
  }
  Future<int> getNumOfPeople() async {
    DocumentReference documentReference =FirebaseFirestore.instance.collection('flights').doc(streamId);
    int num=0;
    await documentReference.get().then((snapshot) {
      num = snapshot.get('peopleInChat');
    });
    return num;
  }
  @override
  void initState() {
    super.initState();
    getNumOfPeople().then((value) {
      setState(() {
        num_of_people = value;
      });
    });
 }
  @override
  Widget build(BuildContext context) {
    queryBanUsers();
    queryBanMessages();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(constants.APPBAR_SIZE),
        child: AppBar(
          centerTitle: false,
          title: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  streamId,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  num_of_people.toString() + " " + howManyHumans(num_of_people),
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            )
          ),
          backgroundColor: constants.accentColor,
          elevation: 0.0,
          leadingWidth: 30,
          leading: Container(
            margin: EdgeInsets.only(left: 8),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
      ),
      body: CommentField(
        streamId: streamId,
        initBanMessage: initBanMessage,
        initBanUsers: initBanUsers,
      ),
    );
  }
  String howManyHumans(int num){
    String result = constants.HUMAN;
    num = num % 100;
    if(num <= 10 || num >= 20){
      num = num % 10;
      switch(num){
        case 2:
        case 3:
        case 4:
          result = constants.HUMANS;
      }
    }
    return result;
  }
}
