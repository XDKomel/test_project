import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
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

import 'choose_flight.dart';

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
    return loading? Loading() : Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(constants.APPBAR_SIZE),
        child: AppBar(
          title: Text(
            '',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF5283B7),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      backgroundColor: Colors.white,
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
        child: SizedBox(
          height: size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 37,
              ),
              Spacer(),
              Center(
                child: Text(constants.TYPE_FLIGHT_ID.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Baloo",
                      color: Colors.black,
                      fontSize: 32,

                      fontWeight: FontWeight.w700,
                    )),
              ),
              SizedBox(
                height: 35,
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
                              //textAlign: TextAlign.center,
                              keyboardType: TextInputType.text,
                              onChanged: (flightId) {
                                this.flightId = flightId.toUpperCase().replaceAll(new RegExp(r"\s+"), "");
                              },

                              style: TextStyle(color: Colors.black),

                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                  fontSize: 18,
                                ),
                                hintText: constants.FLIGHT_ID_EXAMPLE.tr(),
                                border: InputBorder.none,
                              ),
                            ),

                          ],
                        ),
                      ),
                    )
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
                  gradient:  LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF5283B7), Color(0xFFB45590)],
                  ),
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

                          if(document.data()!.containsKey('reference')){
                            String reference = document.get('reference');



                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChooseFlight(
                                    display_id: flightId,
                                    flightId: reference,
                                  )),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChooseFlight(
                                    flightId: flightId,
                                    display_id: flightId,
                                  )),
                            );
                          }

                        } else {
                          setState(() {
                            loading = true;
                          });
                          fetchFlight(flightId).then((list) {
                            if(list.length > 0){
                                String? id = list[0].ident;
                                FirebaseFirestore.instance
                                    .collection('flights')
                                    .doc(id)
                                    .get()
                                    .then((value) {
                                  if (value.exists) {
                                    FirebaseFirestore.instance
                                        .collection('flights')
                                        .doc(flightId).set({
                                      'reference': id
                                    });
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChooseFlight(
                                            flightId: id ?? flightId,
                                            display_id: flightId,
                                          )),
                                    );
                                  } else {
                                    for(Flight obj in list){
                                      FirebaseFirestore.instance
                                        .collection('flights')
                                        .doc(obj.ident).collection('flights').doc(obj.filed_departuretime!.seconds.toString())
                                        .set({ //DO NOT SET JUST ADD NEW ITEMS
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
                                    if(flightId != obj.ident){
                                      FirebaseFirestore.instance
                                          .collection('flights')
                                          .doc(flightId).set({
                                        'reference': obj.ident
                                      });
                                    }

                                    }
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChooseFlight(
                                            flightId: id ?? flightId,
                                            display_id: flightId,
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

  Future<List<Flight>> fetchFlight(String id) async {

    String codes = await rootBundle.loadString('assets/images/codes.json');
    print(id);
    String basicId = id;
    String codedId = "";
    String initCode = id.substring(0,2);
    String realCode = "";

    Map<String,dynamic> codeMap  = json.decode(codes);
    bool containsCode = codeMap.containsKey(initCode);
    if(containsCode){
      realCode = codeMap[initCode];
      id = realCode+id.substring(2);
      codedId = realCode+id.substring(2);
    }else{
      realCode = codeMap[initCode];

      codedId = realCode+id.substring(2);
    }

    print(id);



    var headers = {
      'authorization': 'Basic ' +
          base64Encode(utf8
              .encode('${FlightAwareAPI.USERNAME}:${FlightAwareAPI.PASSWORD}')),
    };
    final response = await http.get(Uri.parse(FlightAwareAPI.BASE_URL + id),
        // Send authorization headers to the backend.
        headers: headers);
    final responseJson = jsonDecode(response.body);
    List<Flight> list = [];
    if (response.statusCode == 200) {
       var data;
      if(responseJson['FlightInfoResult']!=null){
       try{
        data = responseJson['FlightInfoResult']['flights'];
        print(data);
       }catch(e){
         if(containsCode){
           final response = await http.get(Uri.parse(FlightAwareAPI.BASE_URL + basicId), headers: headers);
           var responseJson2 = jsonDecode(response.body) ;
           data = responseJson2['FlightInfoResult']['flights'];
         }
       }
      }
      print(data);
      for (Map<String, dynamic> i in data) {
        list.add(Flight.fromJson(i));
      }
    }
      return list;

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
    //Map<String, dynamic> map = jsonDecode(json[0]);
    if (json.containsKey('error'))
      return Flight(error: true);
    else
      //json = json['FlightInfoResult']['flights'][0];
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
