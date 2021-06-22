import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plane_chat/custom_widgets/flight_card.dart';
import 'package:plane_chat/shared/constants.dart' as constants;

import 'flight_chat.dart';


class ChooseFlight extends StatefulWidget {
  final String flightId;
  final String display_id;
  ChooseFlight({required this.flightId, required this.display_id});
  @override
  _ChooseFlightState createState() => _ChooseFlightState(
    flightId: flightId,
    display_id: display_id
  );
}

class _ChooseFlightState extends State<ChooseFlight> {
  final String flightId;
  final String display_id;
  _ChooseFlightState({required this.flightId, required this.display_id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

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
          child: Container(
            // margin: EdgeInsets.only(top: constants.APPBAR_SIZE),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin:
                  EdgeInsets.only(left: 16, bottom: 8, top: 72),
                  child: Text('Выберите подходящий рейс',
                      style: TextStyle(
                        fontFamily: "Baloo",
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
                  .collection('flights')
                  .doc(flightId).collection('flights').orderBy('filed_departuretime', descending: true)
                  .snapshots(),
        builder: (context, userSnapshot) {
          return userSnapshot.hasData
                  ? ListView.separated(
              padding: const EdgeInsets.only(
                    right: 10, left: 10, top: 10, bottom: 10),
              itemCount: userSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                  DocumentSnapshot flightData =
                  userSnapshot.data!.docs[index];
                  String id = flightData['ident'];
                  //String display_id = flightData['display_id'];
                  Timestamp date = flightData['filed_departuretime'];

                  if(isAfterNow(date))
                  return Container(
                    margin: EdgeInsets.only(bottom: index == userSnapshot.data!.docs.length-1? 60 : 0),
                    child: InkWell(
                      child: FlightCard(
                          id: id,
                          display_id: display_id,
                          time: date
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FlightChat(
                                streamId: id, display_id: display_id, time: date,)),
                        );
                      },
                    ),
                  );
                  return Container();
              },
              separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 10,
                  );
              },
          )
                  : Center(
              child: CircularProgressIndicator(),
          );
        },
      ),
                ),
        ]
            )
          )),
    );
  }
  bool isAfterNow(Timestamp timestamp) {
    return DateTime.now().toUtc().isBefore(
      DateTime.fromMillisecondsSinceEpoch(
        timestamp.millisecondsSinceEpoch,
        isUtc: false,
      ).toUtc(),
    );
  }
}


