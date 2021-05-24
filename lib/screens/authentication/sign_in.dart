import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:plane_chat/screens/home/home.dart';
import 'package:plane_chat/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  String email = '';
  String password = '';
  String error = '';
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        elevation: 0.0,
        title: Text('Sign In'),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
              label: Text('Register'),
              onPressed: () {
                widget.toggleView();
              },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
              //TODO
              // Вынести текстовое поле в отдельный виджет, обернуть его в контейнер
              TextFormField(
                onChanged: (val){
                  setState(() {
                    email = val;
                  });
                },
              ),
              //TODO лучше не использовать sizedbox, а использовать поле margin у
              //TODO Container
              SizedBox(height: 20.0,),
              TextFormField(
                obscureText: true,
                onChanged: (val){
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              ElevatedButton(
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                    if(result == null){
                      setState(() {
                        error = "Could not sign in with these credentials";
                      });
                    }else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    }
                  }
                },
                child: Text('Sign In'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink[400],
                    textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold),

                )
              ),
              SizedBox(height: 12.0,),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        )
      ),
    );
  }
}
