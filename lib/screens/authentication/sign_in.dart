import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:plane_chat/custom_widgets/rounded_button.dart';
import 'package:plane_chat/custom_widgets/rounded_input_field.dart';
import 'package:plane_chat/custom_widgets/rounded_password_field.dart';
import 'package:plane_chat/models/SessionKeeper.dart';
import 'package:plane_chat/models/UserData.dart';
import 'package:plane_chat/screens/authentication/register.dart';
import 'package:plane_chat/screens/home/home.dart';
import 'package:plane_chat/services/auth.dart';
import 'package:plane_chat/shared/loading.dart';
import 'package:plane_chat/shared/regex.dart';
import 'package:plane_chat/shared/constants.dart' as constants;
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String uid='';

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
                  SizedBox(
                    height: 59,
                  ),
                  Center(
                    child: Text(constants.LOG_IN.tr(),
                        style: TextStyle(
                          fontFamily: "Baloo",
                          color: constants.accentColor,
                          fontSize: 30,
                          fontWeight: FontWeight.normal,
                        )),
                  ),

                  SizedBox(
                    height: 34,
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 23),
                    child: RoundedInputField(
                        hintText: constants.EMAIL.tr(),
                        initialValue: email,
                        //textAlign: TextAlign.center,
                        keyboard: TextInputType.emailAddress,
                        width: 0.85,
                        maxHeight: 0.07,
                        maxCharacters: 30,
                        onChanged: (email) {
                          this.email = email;
                        },
                        current: nodes[1],
                        next: nodes[2]),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 23),
                    child: RoundedPasswordField(
                        hintText: constants.PASSWORD.tr(),
                        //textAlign: TextAlign.center,
                        keyboard: TextInputType.visiblePassword,
                        width: 0.85,
                        maxHeight: 0.07,
                        maxCharacters: 30,
                        onChanged: (password) {
                          this.password = password;
                        },
                        current: nodes[2],
                        next: nodes[3]),
                  ),

                 //  Expanded(
                 //    flex: 1,
                 //    child: SizedBox(
                 //      height: 7,
                 //    ),
                 // ),


                  Spacer(),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 15, left: 23, right: 23),
                    child: Center(
                      child:InkWell(
                          child: Text(
                            constants.NOW_A_MEMBER.tr(),
                            style: TextStyle(
                              height: 1,
                              fontSize: 20,
                              color: constants.accentColor,
                              fontFamily: "Baloo",
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onTap: () async {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Register()),
                            );
                          }),
                    ),
                  ),
                    Visibility(
                      visible: isError,
                      maintainState: true,
                      maintainAnimation: true,
                      maintainSize: true,
                      child: Align(
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
                    ),

                  Container(
                    margin: EdgeInsets.only(left: 23, right: 23, bottom: 21),
                    child: RoundedButton(
                      text: constants.LOG_IN.tr(),
                      textColor: Colors.white,
                      textSize: 20,
                      press: () async {
                        errorLabel = "";
                        if(mounted){
                          setState(() {
                            isError = true;
                          });
                        }


                        if (!validateEmail(email)) {
                          errorLabel = constants.INCORRECT_EMAIL.tr();
                        } else if (!validatePassword(password)) {
                          errorLabel = constants.INCORRECT_PASSWORD.tr();
                        } else {
                          if(mounted) {
                            setState(() {
                              isError = false;
                              loading=true;
                            });
                          }

                          dynamic result = await _auth.signInWithEmailAndPassword(
                              email, password);
                          if(mounted){
                            setState(() {
                              loading = false;
                            });
                          }

                          if (result == null) {
                            if(mounted){
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
                                SessionKeeper.user = new UserData(uid: result.uid, name: value);
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

                ],
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
    DocumentReference documentReference =FirebaseFirestore.instance.collection('users').doc(uid);
    String name = '';
    await documentReference.get().then((snapshot) {
      name = snapshot.get('name');
    });
    return name;
  }
}
