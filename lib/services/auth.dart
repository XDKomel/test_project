import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:plane_chat/models/UserData.dart';
import 'package:plane_chat/screens/authentication/authenticate.dart';
import 'package:plane_chat/screens/home/home.dart';
import 'package:plane_chat/services/database.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // UserData? _userFromFirebaseUser(User? user){
  //   return user!=null? UserData(uid: user.uid): null;
  // }
  // Stream<UserData?> get user {
  //   return _auth.authStateChanges()
  //       .map(_userFromFirebaseUser);
  // }

  Stream<User?> get authState => _auth.idTokenChanges();

  Future registerWithEmailAndPassword(String email, String password, String name) async {
    try{
     UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      User? user = result.user;

      await DatabaseService(uid: user!.uid).updateUserData(name, email);

      return user;
    }catch(e){
      print(e.toString());
      return null;
    }
  }


  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);

      User? user = result.user;

      return user;
    }catch(e){
      print(e.toString());
      return null;
    }
  }



  Future signOut() async{
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }

}

