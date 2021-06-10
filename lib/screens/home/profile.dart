import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plane_chat/custom_widgets/rounded_input_field.dart';
import 'package:plane_chat/models/SessionKeeper.dart';
import 'package:plane_chat/screens/authentication/authenticate.dart';
import 'package:plane_chat/services/auth.dart';
import 'package:plane_chat/shared/constants.dart' as constants;
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  String uid;
  Profile({required this.uid});
  @override
  _ProfileState createState() => _ProfileState(uid : uid);
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  String name='';
  String email='';
  String contact='';
  String uid;

  _ProfileState({required this.uid});

  Future<String> getName() async {
    DocumentReference documentReference =FirebaseFirestore.instance.collection('users').doc(uid);
    String name = '';
    await documentReference.get().then((snapshot) {
      name = snapshot.get('name');
    });
    return name;
  }
  Future<String> getEmail() async {
    DocumentReference documentReference =FirebaseFirestore.instance.collection('users').doc(uid);
    String email = '';
    await documentReference.get().then((snapshot) {
      email = snapshot.get('email');
    });
    return email;
  }
  Future<String> getContact() async {
    DocumentReference documentReference =FirebaseFirestore.instance.collection('users').doc(uid);
    String contact = '';
    await documentReference.get().then((snapshot) {
      contact = snapshot.get('contact');
    });
    return contact;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final prefs = SharedPreferences.getInstance().then((value) {
    //   name = value.getString('name')!;
    // });
    getName().then((value) {
      if(value.isNotEmpty)
        setState(() {
        name = value;
      });
    });
    getContact().then((value) {
      if(value.isNotEmpty)
        setState(() {
        contact = value;
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
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                         // Spacer(),
                          SizedBox(
                            height: 34,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0,0 ,50),
                            child: Stack(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 70,
                                  child: ClipOval(child: Image.asset('assets/images/image1.png', height: 150, width: 150, fit: BoxFit.cover,),),
                                ),
                                Positioned(bottom: 1, right: 1 ,child: Container(
                                  height: 40, width: 40,
                                  child: Icon(Icons.add_a_photo, color: Colors.white,),
                                  decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                ))
                              ],
                            ),
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
                            child: RichText(
                              text: TextSpan(
                                text: contact,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Clipboard.setData(ClipboardData(text: contact));
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text("Скопировано в буфер обмена!"),
                                      ));
                                    },
                                style: TextStyle(
                                  fontFamily: "Baloo",
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                )),
                          ),
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

Widget profileView() {
  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(30, 50, 30, 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(height: 50, width: 50 ,child: Icon(Icons.arrow_back_ios, size: 24,color: Colors.black54,), decoration: BoxDecoration(border: Border.all(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10))),),
            Text('Profiles details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            Container(height: 24,width: 24)
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0,0 ,50),
        child: Stack(
          children: <Widget>[
            CircleAvatar(
              radius: 70,
              child: ClipOval(child: Image.asset('assets/images/image1.png', height: 150, width: 150, fit: BoxFit.cover,),),
            ),
            Positioned(bottom: 1, right: 1 ,child: Container(
              height: 40, width: 40,
              child: Icon(Icons.add_a_photo, color: Colors.white,),
              decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
            ))
          ],
        ),
      ),
      Expanded(child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color.fromRGBO(0, 41, 102, 1), constants.accentColor]
            )
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 4),
              child: Container(
                height: 60,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textAlign: TextAlign.start,

                      textInputAction: TextInputAction.next,

                      style: TextStyle(color: Colors.black),

                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                          fontSize: 18,
                        ),

                        hintText: 'Name',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),border: Border.all(width: 1.0, color: Colors.white70)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
              child: Container(
                height: 60,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Email', style: TextStyle(color: Colors.white70),),
                  ),
                ), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),border: Border.all(width: 1.0, color: Colors.white70)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
              child: Container(
                height: 60,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Type something about yourself', style: TextStyle(color: Colors.white70),),
                  ),
                ), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),border: Border.all(width: 1.0, color: Colors.white70)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
              child: Container(
                height: 60,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Phone number', style: TextStyle(color: Colors.white70),),
                  ),
                ), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),border: Border.all(width: 1.0, color: Colors.white70)),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container( height: 70, width: 200,
                  child: Align(child: Text('Save', style: TextStyle(color: Colors.white70, fontSize: 20),),),
                  decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),)
                  ),
                ),
              ),
            )
          ],
        ),
      ))
    ],
  );
}
}
