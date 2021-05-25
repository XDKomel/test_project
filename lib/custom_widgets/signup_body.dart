import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:plane_chat/custom_widgets/rounded_button.dart';
import 'package:plane_chat/custom_widgets/rounded_input_field.dart';
import 'package:plane_chat/custom_widgets/rounded_password_field.dart';
import 'package:plane_chat/screens/authentication/authenticate.dart';
import 'package:plane_chat/screens/authentication/sign_in.dart';
import 'package:plane_chat/screens/home/home.dart';
import 'package:plane_chat/services/auth.dart';
import 'package:plane_chat/shared/constants.dart' as constants;
import 'package:plane_chat/shared/regex.dart';

class SignUpBody extends StatefulWidget {
  final Function toggleSplashScreen;

  SignUpBody({required this.toggleSplashScreen});

  @override
  State<StatefulWidget> createState() => _SignUpBody();

}

class _SignUpBody extends State<SignUpBody> {
  List<FocusNode> nodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode()
  ];

  final AuthService _auth = AuthService();

  bool checkedValue = false;
  String nameSurname = "";

  String email = "";
  String password = "";
  String confPassword = "";
  String errorLabel = "";
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: size.height * 0.01),
        child: SingleChildScrollView(
            child: SizedBox(
          height: size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 59,
              ),
              Center(
                child: Text(constants.REGISTRATION.tr(),
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
                    hintText: constants.NAME.tr(),
                    onChanged: (name) {
                      nameSurname = name;
                    },
                    keyboard: TextInputType.visiblePassword,
                    width: 0.85,
                    maxHeight: 0.07,
                    maxCharacters: 30,
                    current: nodes[0],
                    next: nodes[1]),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 23),
                child: RoundedInputField(
                    hintText: constants.EMAIL.tr(),
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
              // RoundedPasswordField(
              //
              //   hintText: "repeat password".tr(),
              //   keyboard: TextInputType.visiblePassword,
              //   width: 0.85,
              //   maxHeight: 0.07,
              //   maxCharacters: 30,
              //     current: nodes[3],
              //
              //   onChanged: (password){
              //
              //     this.confPassword = password;
              //   },
              // ),
              SizedBox(
                height: 5,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 23),
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
                                  checkedValue = state!;

                                  setState(() {});
                                }),
                          )),
                      privacyPolicyLinkAndTermsOfService()
                    ],
                  )),

              if (isError)
                Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(top: 15, left: 23, right: 23),
                      child: Text(errorLabel,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Baloo",
                            color: Colors.orange,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )),
                    )),

              Spacer(),
              Container(
                margin: EdgeInsets.only(left: 23, right: 23, bottom: 21),
                child: RoundedButton(
                  text: constants.SIGN_UP.tr(),
                  textColor: Colors.white,
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
                    } else if (!checkedValue) {
                      errorLabel = constants.ACCEPT_POLICY.tr();
                    } else {
                      if(mounted) {
                        setState(() {
                          isError = false;
                          widget.toggleSplashScreen();
                        });
                      }

                      dynamic result = await _auth.registerWithEmailAndPassword(
                          email, password);
                      if(mounted){
                        setState(() {
                          widget.toggleSplashScreen();
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      }
                    }
                  },
                ),
              ),

              // RoundedButton(
              //   textColor: constants.accentColor,
              //   color: Colors.white,
              //   textSize: 14,
              //   text: constants.SIGN_UP.tr(),
              //   press: (){
              //     Navigator.pop(context, MaterialPageRoute(
              //         builder: (context) => Authenticate()
              //     )
              //     );
              //   },
              //
              //
              // ),
            ],
          ),
        )),
      ),
    );
  }

  Widget privacyPolicyLinkAndTermsOfService() {
    return Container(
      alignment: Alignment.center,
      //padding: EdgeInsets.all(10),
      child: Center(
          child:InkWell(
            child: Text(
              constants.POLICY_AGREEMENT.tr(),
              style: TextStyle(
                height: 1,
                fontSize: 20,
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
