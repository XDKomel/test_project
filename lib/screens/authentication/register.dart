import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:plane_chat/screens/home/home.dart';
import 'package:plane_chat/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        elevation: 0.0,
        title: Text('Sign Up'),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign In'),
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
                TextFormField(
                  validator: (val) {
                    //TODO лучше проверять регексами правильность ввода

                    val!.isEmpty? 'Enter an email' : null;
                  },
                  onChanged: (val){
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  obscureText: true,
                  validator: (val) {
                    val!.length < 6? 'A password should be at least 6 characters long' : null;
                  },
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
                        dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                        if(result == null){
                          setState(() {
                            error = 'Please, provide valid email and password';
                          });
                        }else{
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                        }
                      }
                    },
                    child: Text('Sign Up'),
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
