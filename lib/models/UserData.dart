import 'package:plane_chat/models/authorities.dart';

class UserData{
  final String uid;
  final String? name;

  List<Authority> authorities=[];
  UserData({required this.uid, this.name});

  factory UserData.initialData() {
    return UserData(
      uid: '',
      // email: '',
      name: '',
      // lastName: '',
      // phone: '',
      // dateCreated: null,
      // isVerified: null,
    );
  }
}