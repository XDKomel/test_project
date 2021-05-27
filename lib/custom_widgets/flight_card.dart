import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:plane_chat/services/FlightData.dart';
import 'package:plane_chat/shared/constants.dart' as constants;


class FlightCard extends StatelessWidget {
  String? id;
  late FlightData flightData;

  FlightCard({this.id});

  Stream<DocumentSnapshot<Map<String, dynamic>>> provideDocumentFieldStream() {
    return FirebaseFirestore.instance.collection('flights').doc(id).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance.collection('flights').doc(id).snapshots().listen((DocumentSnapshot documentSnapshot) {
    //   Map<String, dynamic> firestoreInfo = documentSnapshot.data as Map<String, dynamic>;
    //   flightData = FlightData(originDestination: firestoreInfo['originDestination'], id: id, date: firestoreInfo['date'], time: firestoreInfo['time'],
    //       peopleInChat: firestoreInfo['peopleInChat']);
    //
    // });
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: provideDocumentFieldStream(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            //snapshot -> AsyncSnapshot of DocumentSnapshot
            //snapshot.data -> DocumentSnapshot
            //snapshot.data.data -> Map of fields that you need :)

            Map<String, dynamic>? data = snapshot.data!.data();

            flightData = FlightData(
                originDestination: data!['originDestination'] ?? 'no data',
                date: data['date'] ?? 'no data',
                time: data['time'] ?? 'no data',
                peopleInChat: data['peopleInChat'] ?? 'no data');
            //TODO Okay, now you can use documentFields (json) as needed
            print(snapshot.data!.data().toString());
            // Map<String, dynamic> data = json.decode(snapshot.data!.data().toString());
            return Card(
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
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
                            id!,
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
                                  text: flightData.date + "   ",
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
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: Colors.grey,
                                        size: 30,
                                      ),
                                    ),
                                ),


                        ]
                      ),

                    )
                  ],
                )
                // Center(
                //   child: Text(
                //     id!  + " " + flightData.originDestination + " " + flightData.date + " " + flightData.time + " " + flightData.peopleInChat.toString(),
                //     style: TextStyle(
                //       fontWeight: FontWeight.w500,
                //       color: Colors.orange,
                //     ),
                //   ),
                // ),
                );
          } else
            return SizedBox();
        });
    // return Card(
    //   elevation: 20,
    //   child: Center(
    //     child: Text(
    //       id! + " " + flightData.originDestination + " " + flightData.date + " " + flightData.time,
    //       style: TextStyle(
    //         fontWeight: FontWeight.w500,
    //         color: Colors.orange,
    //       ),
    //     ),
    //   ),
    // );
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
