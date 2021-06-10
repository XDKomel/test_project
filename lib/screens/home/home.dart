import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plane_chat/custom_widgets/chat_widget.dart';
import 'package:plane_chat/custom_widgets/flight_card.dart';
import 'package:plane_chat/models/SessionKeeper.dart';
import 'package:plane_chat/models/UserData.dart';
import 'package:plane_chat/screens/authentication/authenticate.dart';
import 'package:plane_chat/screens/authentication/sign_in.dart';
import 'package:plane_chat/screens/home/add_flight.dart';
import 'package:plane_chat/custom_widgets/flight_list.dart';
import 'package:plane_chat/screens/home/profile.dart';
import 'package:plane_chat/services/FlightData.dart';
import 'package:plane_chat/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:plane_chat/services/database.dart';
import 'package:plane_chat/shared/constants.dart' as constants;
import 'flight_chat.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  late final String uid = FirebaseAuth.instance.currentUser!.uid;
  void queryUserdata() async {
    await FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) async {
      SessionKeeper.user = UserData(uid: uid, name: value.get('name'));
    });
  }
  @override
  void initState() {
    super.initState();
    queryUserdata();
  }
  @override
  Widget build(BuildContext context) {




    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(constants.APPBAR_SIZE),
        child: AppBar(

          title: Text(
            'Flight Buddy',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: constants.accentColor,
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile(uid: uid)),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFlight()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: constants.accentColor,
      ),
      body:  FlightList(),
    );
  }
}
