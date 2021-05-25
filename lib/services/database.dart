import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  late final String uid;
  DatabaseService({ this.uid = 'null'});
  final CollectionReference userInfo = FirebaseFirestore.instance.collection("userInfo");

  Future updateUserData(String name, String phone_number) async {
    return await userInfo.doc(uid).set({
      'name': name,
      'phone': phone_number,
    });
  }

  Stream<QuerySnapshot> get users{
    return userInfo.snapshots();
  }
}