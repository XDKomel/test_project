import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:plane_chat/custom_widgets/rounded_button.dart';
import 'package:plane_chat/custom_widgets/rounded_input_field.dart';
import 'package:plane_chat/custom_widgets/rounded_password_field.dart';
import 'package:plane_chat/models/SessionKeeper.dart';

import 'package:plane_chat/models/user_data.dart';
import 'package:plane_chat/screens/authentication/sign_in.dart';
import 'package:plane_chat/screens/home/home.dart';
import 'package:plane_chat/services/auth.dart';
import 'package:plane_chat/shared/loading.dart';
import 'package:plane_chat/shared/regex.dart';
import 'package:plane_chat/shared/constants.dart' as constants;
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';


bool hidden = true;

class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  List<FocusNode> nodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  final AuthService _auth = AuthService();

  bool checkedValue = false;
  String nameSurname = "";

  String email = "";
  String contact="";
  String password = "";
  String confPassword = "";
  String errorLabel = "";
  bool isError = false;

  bool loading = false;

  void toggleSplashScreen(){
    setState(() {
      loading = !loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading? Loading() : Scaffold(
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
        padding: EdgeInsets.only(top: size.height * 0.01),
        child: SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Spacer(),

                  Center(
                    child: Text(constants.REGISTRATION.tr(),
                        style: TextStyle(
                          fontFamily: "Baloo",
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.normal,
                        )),
                  ),

                  Spacer(),

                  Container(
                    margin: EdgeInsets.only(left: 23, right: 23, bottom: 8),
                    child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient:  LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 224, 224, 224)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(0, 4), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Container(
                            margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                            child: Column(
                              children: [
                                TextFormField(

                                  onChanged: (name) {
                                    nameSurname = name;
                                  },
                                  initialValue: nameSurname,
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.start,

                                  textInputAction: TextInputAction.next,


                                  style: TextStyle(color: Colors.black),


                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                    hintText: constants.NAME.tr(),
                                    border: InputBorder.none,
                                  ),
                                ),
                                Divider(
                                  height: 5,
                                ),
                                TextFormField(
                                  initialValue: contact,
                                  keyboardType: TextInputType.text,
                                  onChanged: (contact) {
                                    this.contact = contact;
                                  },
                                  textAlign: TextAlign.start,

                                  textInputAction: TextInputAction.next,


                                  style: TextStyle(color: Colors.black),


                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                    hintText: constants.CONTACT.tr(),
                                    border: InputBorder.none,
                                  ),
                                ),
                                Divider(
                                  height: 5,
                                ),
                                TextFormField(
                                  textAlign: TextAlign.start,

                                  textInputAction: TextInputAction.next,

                                  initialValue: email,
                                  //textAlign: TextAlign.center,
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (email) {
                                    this.email = email;
                                  },

                                  style: TextStyle(color: Colors.black),


                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                    hintText: constants.EMAIL.tr(),
                                    border: InputBorder.none,
                                  ),
                                ),
                                Divider(
                                  height: 5,
                                ),
                                TextFormField(
                                  textAlign: TextAlign.start,

                                  textInputAction: TextInputAction.next,

                                  obscureText: hidden,
                                  initialValue: password,
                                  //textAlign: TextAlign.center,
                                  keyboardType: TextInputType.visiblePassword,
                                  maxLines: 1,
                                  onChanged: (password) {
                                    this.password = password;
                                  },

                                  style: TextStyle(color: Colors.black),


                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(

                                      onPressed: (){

                                        hidden = !hidden;
                                        setState(() {

                                        });

                                      },
                                      icon:Icon((hidden)?Icons.visibility_off:Icons.visibility),
                                      color: Colors.black,
                                    ),

                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                    hintText: constants.PASSWORD.tr(),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 23),
                  //   child: RoundedInputField(
                  //       hintText: constants.NAME.tr(),
                  //       //textAlign: TextAlign.center,
                  //       onChanged: (name) {
                  //         nameSurname = name;
                  //       },
                  //       initialValue: nameSurname,
                  //       keyboard: TextInputType.text,
                  //       width: 0.85,
                  //       maxHeight: 0.07,
                  //       maxCharacters: 30,
                  //       current: nodes[0],
                  //       next: nodes[1]),
                  // ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 23),
                  //   child: RoundedInputField(
                  //       hintText: constants.CONTACT.tr(),
                  //       //textAlign: TextAlign.center,
                  //       initialValue: contact,
                  //       keyboard: TextInputType.text,
                  //       width: 0.85,
                  //       maxHeight: 0.07,
                  //       maxCharacters: 30,
                  //       onChanged: (contact) {
                  //         this.contact = contact;
                  //       },
                  //       current: nodes[1],
                  //       next: nodes[2]),
                  // ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 23),
                  //   child: RoundedInputField(
                  //       hintText: constants.EMAIL.tr(),
                  //       //textAlign: TextAlign.center,
                  //       initialValue: email,
                  //       keyboard: TextInputType.emailAddress,
                  //       width: 0.85,
                  //       maxHeight: 0.07,
                  //       maxCharacters: 30,
                  //       onChanged: (email) {
                  //         this.email = email;
                  //       },
                  //       current: nodes[2],
                  //       next: nodes[3]),
                  // ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 23),
                  //   child: RoundedPasswordField(
                  //       hintText: constants.PASSWORD.tr(),
                  //       //textAlign: TextAlign.center,
                  //       keyboard: TextInputType.visiblePassword,
                  //       width: 0.85,
                  //       maxHeight: 0.07,
                  //       maxCharacters: 30,
                  //       onChanged: (password) {
                  //         this.password = password;
                  //       },
                  //       current: nodes[3],
                  //       next: nodes[4]),
                  // ),

                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 23, right: 23, top: 27),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: constants.accentColor),
                              child: Transform.scale(
                                scale: 1.5,
                                child: Checkbox(
                                    value: checkedValue,
                                    activeColor: constants.accentColor,
                                    hoverColor: constants.accentColor,
                                    onChanged: (state) {
                                      setState(() {
                                        checkedValue = state!;
                                      });
                                    }),
                              )),
                          privacyPolicyLinkAndTermsOfService()
                        ],
                      )),
                  // Spacer(),


                  // Container(
                  //   alignment: Alignment.center,
                  //   child: Center(
                  //     child:InkWell(
                  //         child: Text(
                  //           constants.ALREADY_A_MEMBER.tr(),
                  //           style: TextStyle(
                  //             height: 1,
                  //             fontSize: 20,
                  //             color: constants.accentColor,
                  //             fontFamily: "Baloo",
                  //             decoration: TextDecoration.underline,
                  //           ),
                  //         ),
                  //         onTap: () async {
                  //           Navigator.pushReplacement(
                  //             context,
                  //             MaterialPageRoute(builder: (context) => SignIn()),
                  //           );
                  //         }),
                  //   ),
                  // ),

                  Spacer(),
                  if (isError)
                    Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15, left: 23, right: 23),
                          child: Text(errorLabel,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Baloo",
                                color: Colors.orange,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              )),
                        )),
                  Container(
                    margin: EdgeInsets.only(bottom: 5, left: 23, right: 23),
                    child: RoundedButton(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(127, 255, 255, 255)],
                        ),
                        text: "Войти",
                        textColor: Color.fromARGB(255, 82, 131, 183),
                        textSize: 16,
                        press: () async {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignIn()),
                          );
                        }),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 23, right: 23, bottom: 21),
                    child: RoundedButton(
                      gradient:  LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF5283B7), Color(0xFFB45590)],
                      ),
                      text: constants.SIGN_UP.tr(),
                      textColor: Colors.white,
                      textSize: 20,
                      press: () async {
                        errorLabel = "";
                        if(mounted){
                          setState(() {
                            isError = true;
                          });
                        }

                        if(!validateName(nameSurname)){
                          errorLabel = constants.INCORRECT_NAME.tr();
                        }else if (!validateEmail(email)) {
                          errorLabel = constants.INCORRECT_EMAIL.tr();
                        } else if (!validatePassword(password)) {
                          errorLabel = constants.INCORRECT_PASSWORD.tr();
                        } else if (!checkedValue) {
                          errorLabel = constants.ACCEPT_POLICY.tr();
                        } else {
                          if(mounted) {
                            setState(() {
                              isError = false;
                              loading=true;
                            });
                          }

                          User result = await _auth.registerWithEmailAndPassword(
                              email, password, nameSurname);
                          if(mounted){
                            setState(() {
                              loading = false;
                            });
                          }

                          if (result == null) {
                            if(mounted){
                              setState(() {
                                errorLabel = constants.REGISTRATION_FAILED;
                                isError = true;
                              });
                            }

                          } else {
                            // FirebaseFirestore.instance.collection('users').doc(result.uid).collection("flights").doc('AB 1234').set({
                            //   'id': 'AB 1234',
                            // });
                            // FirebaseFirestore.instance.collection('users').doc(result.uid).collection("flights").doc('BM 2345').set({
                            //   'id': 'BM 2345',
                            // });
                            FirebaseFirestore.instance.collection('users').doc(result.uid).set({
                              'email': email,
                              'name': nameSurname,
                              'contact': contact,
                            });
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setString('email', email);
                            prefs.setString('name', nameSurname);
                            SessionKeeper.user = new UserData(uid: result.uid, name: nameSurname);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            )),
      ),
    );


  }
  Widget privacyPolicyLinkAndTermsOfService() {
    return Flexible(
      child: Container(
        alignment: Alignment.center,
        //padding: EdgeInsets.all(10),
        child: Center(
          child:InkWell(
              child: Text(
                constants.POLICY_AGREEMENT.tr(),
                style: TextStyle(
                  height: 1,
                  fontSize: 15,
                  color: Colors.black,
                  fontFamily: "Baloo",
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () async {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Tap'),
                ));
              }),
        ),
      ),
    );
  }

  bool validateEmail(String email) {
    return RegExp(r"" + RegexType.EMAIL).hasMatch(email);
  }

  bool validatePassword(String password) {
    return RegExp(r"" + RegexType.PASSWORD).hasMatch(password);
  }

  bool validateName(String name) {
    return RegExp(RegexType.NAME).hasMatch(name);
  }

}

