import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:plane_chat/services/FlightData.dart';
import 'package:plane_chat/shared/constants.dart' as constants;


class FlightCard extends StatelessWidget {
  String id;
  String display_id;
  late FlightData flightData;
  Timestamp time;

  FlightCard({required this.id, required this.display_id, required this.time});

  Stream<DocumentSnapshot<Map<String, dynamic>>> provideDocumentFieldStream() {
    return FirebaseFirestore.instance.collection('flights').doc(id).collection('flights').doc(time.seconds.toString()).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: provideDocumentFieldStream(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic>? data = snapshot.data!.data();
            Timestamp t = data!['filed_departuretime'];
            DateTime datetime = t.toDate();

            String hour = (datetime.hour<10? "0" : "") + datetime.hour.toString();
            String minute = (datetime.minute<10? "0" : "") + datetime.minute.toString();
            flightData = FlightData(
                originDestination: data['origin'] + "-" + data['destination'],
                date: date(datetime),
                time: hour + ":" + minute,
                peopleInChat: data['peopleInChat'] ?? 0);
            return Container(
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
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.3),
                      //     spreadRadius: 2,
                      //     blurRadius: 3,
                      //     offset: Offset(0, 4), // changes position of shadow
                      //   ),
                      // ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(15),
                              child: Text(
                                flightData.originDestination,
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 15, right: 15, bottom: 25),
                              child: Text(
                                display_id,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(bottom: 15, left: 15, right: 15),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: flightData.date + " ",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    TextSpan(
                                      text: flightData.time,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                            Container(
                                      alignment: Alignment.topRight,
                                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 25, top: 15),
                                      child: Text(
                                        flightData.peopleInChat.toString() + " " + howManyHumans(flightData.peopleInChat),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    // Align(
                                    //     alignment: Alignment.centerRight,
                                    //     child: Container(
                                    //       alignment: Alignment.centerRight,
                                    //       margin: EdgeInsets.only(right: 5),
                                    //       child: Icon(
                                    //         Icons.arrow_forward_ios_outlined,
                                    //         color: Colors.grey,
                                    //         size: 30,
                                    //       ),
                                    //     ),
                                    // ),


                            ]
                          ),

                        )
                      ],
                    ),
                  )
                  ),
            );
          } else
            return SizedBox();
        });
  }

  String date(DateTime tm) {
    if(tm==null) return '';
    String month='';
    switch (tm.month) {
      case 1:
        month = constants.JANUARY;
        break;
      case 2:
        month = constants.FEBRUARY;
        break;
      case 3:
        month = constants.MARCH;
        break;
      case 4:
        month = constants.APRIL;
        break;
      case 5:
        month = constants.MAY;
        break;
      case 6:
        month = constants.JUNE;
        break;
      case 7:
        month = constants.JULY;
        break;
      case 8:
        month = constants.AUGUST;
        break;
      case 9:
        month = constants.SEPTEMBER;
        break;
      case 10:
        month = constants.OCTOBER;
        break;
      case 11:
        month = constants.NOVEMBER;
        break;
      case 12:
        month = constants.DECEMBER;
        break;
    }
    return tm.day.toString() + " " + month + " " + tm.year.toString() + " в ";
  }

  String howManyHumans(int num){
    String result = constants.HUMAN;
    num = num % 100;
    if(num <= 10 || num >= 20){
      num = num % 10;
      switch(num){
        case 2:
        case 3:
        case 4:
          result = constants.HUMANS;
      }
    }
    return result;
  }
}
