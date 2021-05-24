import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plane_chat/models/UserData.dart';
import 'package:plane_chat/screens/authentication/authenticate.dart';
import 'package:provider/provider.dart';

import 'home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    //final user = context.watch<User>();
    if(user == null){
      return Authenticate();
    }else{
      return Home();
    }


  }
}
