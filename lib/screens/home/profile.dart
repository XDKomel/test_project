import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plane_chat/custom_widgets/rounded_input_field.dart';
import 'package:plane_chat/models/SessionKeeper.dart';
import 'package:plane_chat/screens/authentication/authenticate.dart';
import 'package:plane_chat/services/auth.dart';
import 'package:plane_chat/shared/constants.dart' as constants;
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  String name='';
  String email='';

  Future<String> getName() async {
    DocumentReference documentReference =FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
    String name = '';
    await documentReference.get().then((snapshot) {
      name = snapshot.get('name');
    });
    return name;
  }
  Future<String> getEmail() async {
    DocumentReference documentReference =FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
    String email = '';
    await documentReference.get().then((snapshot) {
      email = snapshot.get('email');
    });
    return email;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final prefs = SharedPreferences.getInstance().then((value) {
    //   name = value.getString('name')!;
    // });
    getName().then((value) {
      setState(() {
        name = value;
      });
    });
    getEmail().then((value) {
      setState(() {
        email = value;
      });
    });
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(constants.APPBAR_SIZE),
          child: AppBar(
            title: Text(
              constants.PROFILE,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            backgroundColor: constants.accentColor,
            elevation: 0.0,
            leadingWidth: 30,
            leading: Container(
              margin: EdgeInsets.only(left: 8),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            actions: <Widget>[
              Icon(
                Icons.logout,
                size: 30,
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: TextButton(
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
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
              )
            ],
          ),
        ),
        body: Container(
            padding: EdgeInsets.only(top: size.height * 0.01),
            child: SingleChildScrollView(
                child: SizedBox(
                    height: size.height,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                         // Spacer(),
                          SizedBox(
                            height: 34,
                          ),
                          Center(
                            child: Text(name,
                                style: TextStyle(
                                  fontFamily: "Baloo",
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Center(
                            child: Text(email,
                                style: TextStyle(
                                  fontFamily: "Baloo",
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                )),
                          ),

                          SizedBox(
                            height: 34,
                          ),

                          // Container(
                          //   margin: EdgeInsets.symmetric(horizontal: 23),
                          //   child: RoundedInputField(
                          //       initialValue: name,
                          //       //textAlign: TextAlign.center,
                          //       keyboard: TextInputType.text,
                          //       width: 0.85,
                          //       maxHeight: 0.07,
                          //       maxCharacters: 30,
                          //       onChanged: (name) {
                          //         this.name = name;
                          //       },
                          // ),
                          // ),
                          Spacer(),
                        ])))));
  }


}
