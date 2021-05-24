import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plane_chat/models/user_data.dart';
import 'package:plane_chat/screens/authentication/authenticate.dart';
import 'package:provider/provider.dart';

import 'home/home.dart';

//TODO Зачем нужен враппер? Я не нашёл, где ты его в коде юзаешь

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
