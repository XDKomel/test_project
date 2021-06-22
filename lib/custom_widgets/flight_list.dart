import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plane_chat/custom_widgets/flight_card.dart';
import 'package:plane_chat/screens/authentication/authenticate.dart';
import 'package:plane_chat/screens/home/flight_chat.dart';
import 'package:plane_chat/screens/home/profile.dart';
import 'package:plane_chat/services/FlightData.dart';
import 'package:plane_chat/services/auth.dart';
import 'package:plane_chat/shared/constants.dart' as constants;
import 'package:provider/provider.dart';

class FlightList extends StatefulWidget {
  @override
  _FlightListState createState() => _FlightListState();
}

class _FlightListState extends State<FlightList> {
  final AuthService _auth = AuthService();
  late final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection("flights")
          .orderBy('filed_departuretime', descending: true)
          .snapshots(),
      builder: (context, userSnapshot) {
        bool flag = true;
        return userSnapshot.hasData
            ? userSnapshot.data!.docs.length == 0
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 23),
                    child: Center(
                      child: Text(
                        constants.NO_FLIGHTS,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(
                        right: 10, left: 10, top: 10, bottom: 10),
                    itemCount: userSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot flightData =
                          userSnapshot.data!.docs[index];
                      String id = flightData['id'];
                      String display_id = flightData['display_id'];
                      Timestamp date = flightData['filed_departuretime'];
                       if (isBeforeNow(date) && flag){
                        flag = false;
                        double top = index == 0? 72 : 0;
                        return Column(children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin:
                            EdgeInsets.only(left: 16, bottom: 8, top: top),
                            child: Text('Завершённые рейсы',
                                style: TextStyle(
                                  fontFamily: "Baloo",
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Container(
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
                          )
                        ]);
                      } else if (index == 0) {
                         return Column(children: [
                           Container(
                             alignment: Alignment.centerLeft,
                             margin:
                             EdgeInsets.only(left: 16, bottom: 8, top: 72),
                             child: Text('Предстоящие рейсы',
                                 style: TextStyle(
                                   fontFamily: "Baloo",
                                   color: Colors.black,
                                   fontSize: 24,
                                   fontWeight: FontWeight.bold,
                                 )),
                           ),
                           Container(
                             margin: EdgeInsets.only(bottom: index == userSnapshot.data!.docs.length-1? 60 : 0),
                             child: InkWell(
                               child: FlightCard(
                                 id: id,
                                 display_id: display_id,
                                 time: date,
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
                           )
                         ]);
                       }
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
    );
  }

  Future<DocumentSnapshot> getFlights(String flightId) async {
    return await FirebaseFirestore.instance
        .collection('flights')
        .doc(flightId)
        .get();
  }

  bool isBeforeNow(Timestamp timestamp) {
    return DateTime.now().toUtc().isAfter(
      DateTime.fromMillisecondsSinceEpoch(
        timestamp.millisecondsSinceEpoch,
        isUtc: false,
      ).toUtc(),
    );
  }
}
