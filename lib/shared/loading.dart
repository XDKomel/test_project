import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:plane_chat/shared/constants.dart' as constants;

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: constants.accentColor,
      child: Center(
        child: SpinKitWanderingCubes(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}
