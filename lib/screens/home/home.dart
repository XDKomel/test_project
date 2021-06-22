import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plane_chat/custom_widgets/chat_widget.dart';
import 'package:plane_chat/custom_widgets/flight_card.dart';
import 'package:plane_chat/custom_widgets/rounded_button.dart';
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
import 'package:easy_localization/easy_localization.dart';
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
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) async {
      SessionKeeper.user = UserData(uid: uid, name: value.get('name'));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    queryUserdata();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(constants.APPBAR_SIZE),
        child: AppBar(
          // title: Text(
          //   'Flight Buddy',
          //   style: TextStyle(color: Colors.white),
          // ),

        // flexibleSpace: Container( //appBar gradient
        // decoration: BoxDecoration(
        // gradient:  LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [Color(0xFF5283B7), Color(0x775283B7), Color(0x335283B7), Colors.transparent],
        // ),
        // ),
        // ),

          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile(uid: uid)),
                );
              },
              label: Container(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  constants.PROFILE,
                  style: TextStyle(color: Color.fromARGB(255, 82, 131, 183), fontSize: 15),
                ),
              ),
              icon: Icon(
                Icons.person_outline,
                color: Color.fromARGB(255, 82, 131, 183),
                size: 30,
              ),
            )
          ],
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: constants.gradientStart,
            end: constants.gradientEnd,
            colors: [
              constants.gradientBeginColor,
              constants.gradientBeginColor,
              constants.gradientEndColor,
            ],
          )),
          child: Container(
           // margin: EdgeInsets.only(top: constants.APPBAR_SIZE),
            child: Stack(children: [
              ShaderMask(
                  shaderCallback: (Rect rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.purple, Colors.transparent, Colors.transparent, Colors.purple],
                      stops: [0.0, 0.1, 0.9, 1.0], // 10% purple, 80% transparent, 10% purple
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstOut,
                  child: FlightList()
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 4),
                child: RoundedButton(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF5283B7), Color(0xFFB45590)],
                  ),
                  text: constants.ADD_FLIGHT.tr(),
                  textColor: Colors.white,
                  textSize: 16,
                  press: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddFlight()),
                    );
                  },
                ),
              ),
            ]),
          )),
    );
  }
}
