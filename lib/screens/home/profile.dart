import 'package:flutter/material.dart';
import 'package:plane_chat/screens/authentication/authenticate.dart';
import 'package:plane_chat/services/auth.dart';
import 'package:plane_chat/shared/constants.dart' as constants;


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(constants.APPBAR_SIZE),
          child: AppBar(
            title: Text(
              '',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: constants.accentColor,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.popUntil(context, (route) => false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Authenticate()),
                    );
                  },
                  child: Text(
                    constants.LOG_OUT,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15
                    ),
                  ))
            ],
          ),
        ),

        body: Container()
    );
  }


  // @override
  // Widget build(BuildContext context) {
  //
  //   return Scaffold(
  //           appBar: PreferredSize(
  //             preferredSize: Size.fromHeight(constants.APPBAR_SIZE),
  //             child: AppBar(
  //               title: Text(
  //                 '',
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //               backgroundColor: constants.accentColor,
  //               elevation: 0.0,
  //               leading: IconButton(
  //                 icon: Icon(Icons.arrow_back_ios),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //               actions: <Widget>[
  //                 TextButton(
  //                     onPressed: () async {
  //                       await _auth.signOut();
  //                       Navigator.popUntil(context, (route) => false);
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(builder: (context) => Authenticate()),
  //                       );
  //                     },
  //                     child: Text(
  //                       constants.LOG_OUT,
  //                       style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 15
  //                       ),
  //                     ))
  //               ],
  //             ),
  //           ),
  //       body: profileView()// This trailing comma makes auto-formatting nicer for build methods.
  //   );
  // }
  //
  // Widget profileView() {
  //   return Column(
  //     children: <Widget>[
  //       Padding(
  //         padding: EdgeInsets.fromLTRB(30, 50, 30, 30),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: <Widget>[
  //             Container(height: 50, width: 50 ,child: Icon(Icons.arrow_back_ios, size: 24,color: Colors.black54,), decoration: BoxDecoration(border: Border.all(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10))),),
  //             Text('Profiles details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
  //             Container(height: 24,width: 24)
  //           ],
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.fromLTRB(0, 0,0 ,50),
  //         child: Stack(
  //           children: <Widget>[
  //             CircleAvatar(
  //               radius: 70,
  //               child: ClipOval(child: Image.asset('assets/images/image1.png', height: 150, width: 150, fit: BoxFit.cover,),),
  //             ),
  //             Positioned(bottom: 1, right: 1 ,child: Container(
  //               height: 40, width: 40,
  //               child: Icon(Icons.add_a_photo, color: Colors.white,),
  //               decoration: BoxDecoration(
  //                   color: Colors.deepOrange,
  //                   borderRadius: BorderRadius.all(Radius.circular(20))
  //               ),
  //             ))
  //           ],
  //         ),
  //       ),
  //       Expanded(child: Container(
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
  //             gradient: LinearGradient(
  //                 begin: Alignment.topRight,
  //                 end: Alignment.bottomLeft,
  //                 colors: [Color.fromRGBO(0, 41, 102, 1), constants.accentColor]
  //             )
  //         ),
  //         child: Column(
  //           children: <Widget>[
  //             Padding(
  //               padding: const EdgeInsets.fromLTRB(20, 25, 20, 4),
  //               child: Container(
  //                 height: 60,
  //                 child: Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: TextFormField(
  //                       textAlign: TextAlign.start,
  //
  //                       textInputAction: TextInputAction.next,
  //
  //                       style: TextStyle(color: Colors.black),
  //
  //                       decoration: InputDecoration(
  //                         hintStyle: TextStyle(
  //                           fontWeight: FontWeight.normal,
  //                           color: Colors.grey,
  //                           fontSize: 18,
  //                         ),
  //
  //                         hintText: 'Name',
  //                         border: InputBorder.none,
  //                       ),
  //                     ),
  //                   ),
  //                 ), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),border: Border.all(width: 1.0, color: Colors.white70)),
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
  //               child: Container(
  //                 height: 60,
  //                 child: Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Text('Email', style: TextStyle(color: Colors.white70),),
  //                   ),
  //                 ), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),border: Border.all(width: 1.0, color: Colors.white70)),
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
  //               child: Container(
  //                 height: 60,
  //                 child: Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Text('Type something about yourself', style: TextStyle(color: Colors.white70),),
  //                   ),
  //                 ), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),border: Border.all(width: 1.0, color: Colors.white70)),
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
  //               child: Container(
  //                 height: 60,
  //                 child: Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Text('Phone number', style: TextStyle(color: Colors.white70),),
  //                   ),
  //                 ), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),border: Border.all(width: 1.0, color: Colors.white70)),
  //               ),
  //             ),
  //             Expanded(
  //               child: Align(
  //                 alignment: Alignment.bottomRight,
  //                 child: Container( height: 70, width: 200,
  //                   child: Align(child: Text('Save', style: TextStyle(color: Colors.white70, fontSize: 20),),),
  //                   decoration: BoxDecoration(
  //                       color: Colors.deepOrange,
  //                       borderRadius: BorderRadius.only(topLeft: Radius.circular(30),)
  //                   ),
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       ))
  //     ],
  //   );
  // }




}
