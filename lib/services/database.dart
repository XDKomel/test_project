import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plane_chat/services/FlightData.dart';

class DatabaseService{
  late final String uid;
  DatabaseService({ this.uid = 'null'});
  final CollectionReference userInfo = FirebaseFirestore.instance.collection("users");

  Future updateUserData(String name, String phone_number) async {
    return await userInfo.doc(uid).set({
      'name': name,
      'phone': phone_number,
    });
  }

  List<FlightData>? _flightListFromQuerySnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) {
      return FlightData(
          originDestination: doc.get('originDestination') ?? "",
          id: doc.get('id') ?? "",
          date: doc.get('date') ?? "",
          time: doc.get('data') ?? "",
          peopleInChat: doc.get('peopleInChat') ?? 0
      );
    }).toList();
  }


  // get stream of user data
  Stream<List<FlightData>?> get users{
    return userInfo.doc(uid).collection("flights").snapshots().map(_flightListFromQuerySnapshot);
  }
}