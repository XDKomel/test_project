import 'package:flutter/material.dart';
import 'package:plane_chat/screens/authentication/authenticate.dart';
import 'package:plane_chat/screens/home/flight_chat.dart';
import 'package:plane_chat/services/FlightData.dart';
import 'package:plane_chat/services/auth.dart';
import 'package:plane_chat/shared/constants.dart' as constants;
import 'package:provider/provider.dart';

class FlightList extends StatefulWidget {
  @override
  _FlightListState createState() => _FlightListState();
}

class Data {
  Map fetched_data = {
    "data": [
      {"id": 111, "name": "abc"},
      {"id": 222, "name": "pqr"},
      {"id": 333, "name": "abc"}
    ]
  };
  late List _data;

//function to fetch the data

  Data() {
    _data = fetched_data["data"];
  }

  int getId(int index) {
    return _data[index]["id"];
  }

  String getName(int index) {
    return _data[index]["name"];
  }

  int getLength() {
    return _data.length;
  }
}

class _FlightListState extends State<FlightList> {
  final AuthService _auth = AuthService();
  Data _data = new Data();

  @override
  Widget build(BuildContext context) {
    final flights = Provider.of<List<FlightData>>(context);
    flights.forEach((flight) {
      print(flight.originDestination);
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'FlightBuddy',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: constants.accentColor,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Authenticate()),
                );
              },
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: Text('Log out'))
        ],
      ),
        body: ListView.builder(
          padding: const EdgeInsets.all(5.5),
          itemCount: _data.getLength(),
          itemBuilder: _itemBuilder,
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return InkWell(
      child: Container(
        height: 50,
        child: Card(
          elevation: 20,
          child: Center(
            child: Text(
              "${_data.getName(index)}",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.orange,
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FlightChat()),
        );
      },
    );
  }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(
//           'FlightBuddy',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: constants.accentColor,
//         elevation: 0.0,
//         actions: <Widget>[
//           TextButton.icon(
//               onPressed: () async {
//                 await _auth.signOut();
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => Authenticate()),
//                 );
//               },
//               icon: Icon(
//                 Icons.person,
//                 color: Colors.white,
//               ),
//               label: Text('Log out'))
//         ],
//       ),
//       body: GestureDetector(
//         onTap: () {
//           Navigator.of(context).pushReplacement(MaterialPageRoute(
//               builder: (context) => FlightChat()
//           ));
//         },
//         child: Center(
//           child: Card(
//               elevation: 20,
//               color: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(50),
//               ),
//               child: SizedBox(
//                 width: 300,
//                 height: 200,
//                 child:
//                     Center(child: Text('Куда летим, куда пердим?', style: TextStyle(fontSize: 50))),
//               )),
//         ),
//       )
//   );
// }

}
