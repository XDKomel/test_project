import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:plane_chat/custom_widgets/rounded_button.dart';
import 'package:plane_chat/custom_widgets/rounded_input_field.dart';
import 'package:plane_chat/custom_widgets/rounded_password_field.dart';
import 'package:plane_chat/screens/authentication/register.dart';
import 'package:plane_chat/screens/home/flight_chat.dart';
import 'package:plane_chat/screens/home/home.dart';
import 'package:plane_chat/services/auth.dart';
import 'package:plane_chat/shared/loading.dart';
import 'package:plane_chat/shared/regex.dart';
import 'package:plane_chat/shared/constants.dart' as constants;
import 'package:easy_localization/easy_localization.dart';

class AddFlight extends StatefulWidget {
  @override
  _AddFlightState createState() => _AddFlightState();
}

class _AddFlightState extends State<AddFlight> {
  final AuthService _auth = AuthService();

  String flightId = "";
  String errorLabel = "";
  bool isError = false;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(constants.APPBAR_SIZE),
        child: AppBar(
          title: Text(
            '',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: constants.accentColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: size.height * 0.01),
        child: SizedBox(
          height: size.height,
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            height: 37,
          ),
          Center(
            child: Text(constants.TYPE_FLIGHT_ID.tr(),
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
              hintText: constants.FLIGHT_ID_EXAMPLE.tr(),
              keyboard: TextInputType.text,
              width: 0.85,
              maxHeight: 0.07,
              maxCharacters: 30,
              textAlign: TextAlign.center,
              onChanged: (flightId) {
                this.flightId = flightId;
              },
            ),
          ),

          Spacer(),
          if (isError)
            Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(bottom: 15, left: 23, right: 23),
                  child: Text(
                  errorLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Baloo",
                        color: Colors.orange,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      )),
                )),

          Container(
            margin: EdgeInsets.only(left: 23, right: 23, bottom: 21),
            child: RoundedButton(
              text: constants.CONTINUE.tr(),
              textColor: Colors.white,
              textSize: 20,
              press: () async {
                try {
                  await FirebaseFirestore.instance.collection('flights').doc(
                      flightId).get().then((document) {
                    if (document.exists) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FlightChat(streamId: flightId,)),
                      );
                    } else {
                      setState(() {
                        errorLabel = constants.FLIGHT_NOT_FOUND;
                        isError = true;
                      });
                    }
                  });
                }catch(e){
                  setState(() {
                    errorLabel = constants.TYPE_FLIGHT_ID;
                    isError = true;
                  });
                }
              },
            ),
          ),
        ],
          ),
        ),
      ),
    );
  }


}
