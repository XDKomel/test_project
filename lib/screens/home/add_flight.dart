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
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

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
                margin: EdgeInsets.only(left: 23, right: 23, bottom: 21),
                child: RoundedButton(
                  text: constants.CONTINUE.tr(),
                  textColor: Colors.white,
                  textSize: 20,
                  press: () async {
                    if (flightId.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection('flights')
                          .doc(flightId)
                          .get()
                          .then((document) {
                        if (document.exists) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FlightChat(
                                      streamId: flightId,
                                    )),
                          );
                        } else {
                          fetchFlight(flightId).then((obj) {
                            if (!obj.error) {
                              FirebaseFirestore.instance
                                  .collection('flights')
                                  .doc(obj.ident)
                                  .get()
                                  .then((value) {
                                if (document.exists) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FlightChat(
                                              streamId: obj.ident ?? flightId,
                                            )),
                                  );
                                } else {
                                  FirebaseFirestore.instance
                                      .collection('flights')
                                      .doc(obj.ident)
                                      .set({
                                    'ident': obj.ident,
                                    'aircrafttype': obj.aircrafttype,
                                    'filed_ete': obj.filed_ete,
                                    'filed_time': obj.filed_time,
                                    'filed_departuretime': obj.filed_departuretime,
                                    'filed_airspeed_kts': obj.filed_airspeed_kts,
                                    'filed_airspeed_mach': obj.filed_airspeed_mach,
                                    'filed_altitude': obj.filed_altitude,
                                    'route': obj.route,
                                    'actualdeparturetime': obj.actualdeparturetime,
                                    'estimatedarrivaltime':
                                    obj.estimatedarrivaltime,
                                    'actualarrivaltime': obj.actualarrivaltime,
                                    'diverted': obj.diverted,
                                    'origin': obj.origin,
                                    'originName': obj.originName,
                                    'originCity': obj.originCity,
                                    'destination': obj.destination,
                                    'destinationName': obj.destinationName,
                                    'destinationCity': obj.destinationCity,
                                    'peopleInChat': 0
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FlightChat(
                                          streamId: obj.ident ?? flightId,
                                        )),
                                  );
                                }
                              });

                            } else {
                              setState(() {
                                errorLabel = constants.FLIGHT_NOT_FOUND;
                                isError = true;
                              });
                            }

                            print(obj.toString());
                          });
                        }
                      });
                    } else {
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

  Future<Flight> fetchFlight(String id) async {
    var headers = {
      'authorization': 'Basic ' +
          base64Encode(utf8
              .encode('${FlightAwareAPI.USERNAME}:${FlightAwareAPI.PASSWORD}')),
    };
    final response = await http.get(Uri.parse(FlightAwareAPI.BASE_URL + id),
        // Send authorization headers to the backend.
        headers: headers);
    final responseJson = jsonDecode(response.body);

    return Flight.fromJson(responseJson);
  }
}

class FlightAwareAPI {
  static const String BASE_URL =
      'http://flightxml.flightaware.com/json/FlightXML2/FlightInfo?ident=';
  static const String USERNAME = 'flightbuddy2021';
  static const String PASSWORD = '216127c9a05266e6cbb1003dd506b2f347fdcf26';
}

class Flight {
  final String? ident;
  final String? aircrafttype;
  final String? filed_ete;
  final Timestamp? filed_time;
  final Timestamp? filed_departuretime;
  final int? filed_airspeed_kts;
  final String? filed_airspeed_mach;
  final int? filed_altitude;
  final String? route;
  final Timestamp? actualdeparturetime;
  final Timestamp? estimatedarrivaltime;
  final Timestamp? actualarrivaltime;
  final String? diverted;
  final String? origin;
  final String? originName;
  final String? originCity;
  final String? destination;
  final String? destinationName;
  final String? destinationCity;
  bool error = false;

  Flight(
      {this.ident,
      this.aircrafttype,
      this.filed_ete,
      this.filed_time,
      this.filed_departuretime,
      this.filed_airspeed_kts,
      this.filed_airspeed_mach,
      this.filed_altitude,
      this.route,
      this.actualdeparturetime,
      this.estimatedarrivaltime,
      this.actualarrivaltime,
      this.diverted,
      this.originName,
      this.originCity,
      this.destinationName,
      this.destinationCity,
      this.origin,
      this.destination,
      required this.error});

  factory Flight.fromJson(Map<String, dynamic> json) {
    if (json['error'] != null)
      return Flight(error: true);
    else
      json = json['FlightInfoResult']['flights'][0];
    return Flight(
      error: false,
      ident: json['ident'],
      aircrafttype: json['aircrafttype'],
      filed_ete: json['filed_ete'],
      filed_time:
          Timestamp.fromMillisecondsSinceEpoch(json['filed_time'] * 1000),
      filed_departuretime: Timestamp.fromMillisecondsSinceEpoch(
          json['filed_departuretime'] * 1000),
      filed_airspeed_kts: json['filed_airspeed_kts'],
      filed_airspeed_mach: json['filed_airspeed_mach'],
      filed_altitude: json['filed_altitude'],
      route: json['route'],
      actualdeparturetime: Timestamp.fromMillisecondsSinceEpoch(
          json['actualdeparturetime'] * 1000),
      estimatedarrivaltime: Timestamp.fromMillisecondsSinceEpoch(
          json['estimatedarrivaltime'] * 1000),
      actualarrivaltime: Timestamp.fromMillisecondsSinceEpoch(
          json['actualarrivaltime'] * 1000),
      diverted: json['diverted'],
      origin: json['origin'],
      originName: json['originName'],
      originCity: json['originCity'],
      destination: json['destination'],
      destinationName: json['destinationName'],
      destinationCity: json['destinationCity'],
    );
  }
}
