import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:plane_chat/custom_widgets/rounded_button.dart';
import 'package:plane_chat/custom_widgets/rounded_input_field.dart';
import 'package:plane_chat/custom_widgets/rounded_password_field.dart';
import 'package:plane_chat/models/SessionKeeper.dart';

import 'package:plane_chat/models/user_data.dart';
import 'package:plane_chat/screens/authentication/register.dart';
import 'package:plane_chat/screens/home/home.dart';
import 'package:plane_chat/services/auth.dart';
import 'package:plane_chat/shared/loading.dart';
import 'package:plane_chat/shared/regex.dart';
import 'package:plane_chat/shared/constants.dart' as constants;
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool hidden = true;

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  List<FocusNode> nodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode()
  ];

  final AuthService _auth = AuthService();

  bool checkedValue = false;
  String uid = '';

  String email = "";
  String password = "";
  String errorLabel = "";
  bool isError = false;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (loading) {
      return Loading();
    } else {
      return Scaffold(
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
          padding: EdgeInsets.only(top: size.height * 0.01,),
          child: SingleChildScrollView(
              child: SizedBox(
                height: size.height,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      //Spacer(),
                      SizedBox(
                        height: 59,
                      ),
                      Center(
                        child: Text(constants.LOG_IN.tr(),
                            style: TextStyle(
                              fontFamily: "Baloo",
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.normal,
                            )),
                      ),

                      SizedBox(
                        height: 34,
                      ),
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
                                      textAlign: TextAlign.start,

                                      textInputAction: TextInputAction.next,

                                      initialValue: email,
                                      //textAlign: TextAlign.center,
                                      keyboardType: TextInputType.emailAddress,
                                      onChanged: (email) {
                                        this.email = email;
                                      },

                                      style: TextStyle(color: Colors.black),

                                      autofillHints: [AutofillHints.email],
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

                                      autofillHints: [AutofillHints.password],

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
                      //       hintText: constants.EMAIL.tr(),
                      //       initialValue: email,
                      //       //textAlign: TextAlign.center,
                      //       keyboard: TextInputType.emailAddress,
                      //       width: 0.85,
                      //       maxHeight: 0.07,
                      //       maxCharacters: 30,
                      //       onChanged: (email) {
                      //         this.email = email;
                      //       },
                      //       current: nodes[1],
                      //       next: nodes[2]),
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
                      //       current: nodes[2],
                      //       next: nodes[3]),
                      // ),


                      // Spacer(),

                      Container(
                        margin: EdgeInsets.only(left: 23, right: 23, bottom: 5),
                        child: RoundedButton(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFF5283B7), Color(0xFFB45590)],
                          ),
                          text: constants.LOG_IN.tr(),
                          textColor: Colors.white,
                          textSize: 16,
                          press: () async {
                            errorLabel = "";
                            if (mounted) {
                              setState(() {
                                isError = true;
                              });
                            }

                            if (!validateEmail(email)) {
                              errorLabel = constants.INCORRECT_EMAIL.tr();
                            } else if (!validatePassword(password)) {
                              errorLabel = constants.INCORRECT_PASSWORD.tr();
                            } else {
                              if (mounted) {
                                setState(() {
                                  isError = false;
                                  loading = true;
                                });
                              }

                              dynamic result = await _auth.signInWithEmailAndPassword(
                                  email, password);
                              if (mounted) {
                                setState(() {
                                  loading = false;
                                });
                              }

                              if (result == null) {
                                if (mounted) {
                                  setState(() {
                                    errorLabel = constants.SIGN_IN_FAILED;
                                    isError = true;
                                  });
                                }
                              } else {
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setString('email', email);
                                uid = result.uid;
                                getName().then((value) {
                                  setState(() {
                                    prefs.setString('name', value);
                                    SessionKeeper.user =
                                    new UserData(uid: result.uid, name: value);
                                    SessionKeeper.email = email;
                                  });
                                });
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => Home()),
                                );
                              }
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 15, left: 23, right: 23),
                        child: RoundedButton(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(127, 255, 255, 255)],
                            ),
                            text: constants.REGISTRATE.tr(),
                            textColor: Color.fromARGB(255, 82, 131, 183),
                            textSize: 16,
                            press: () async {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Register()),
                              );
                            }),
                      ),

                      Visibility(
                        visible: isError,
                        maintainState: true,
                        maintainAnimation: true,
                        maintainSize: true,
                        child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin:
                              EdgeInsets.only(bottom: 15, left: 23, right: 23),
                              child: Text(errorLabel,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Baloo",
                                    color: Colors.orange,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  )),
                            )),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      );
    }
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

  Future<String> getName() async {
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection('users').doc(uid);
    String name = '';
    await documentReference.get().then((snapshot) {
      name = snapshot.get('name');
    });
    return name;
  }
}