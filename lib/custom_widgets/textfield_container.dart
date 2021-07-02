import 'package:flutter/material.dart';
import 'package:plane_chat/shared/constants.dart' as constants;



class TextFieldContainer extends StatelessWidget {
  final Widget? child;
  final double width;
  const TextFieldContainer({
    Key? key,
    this.child,
    this.width = 0.8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // h and w of screen

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: (size.width>300)?300:size.width*width,
      decoration: BoxDecoration(
        border: Border.all(
          color: constants.kPrimaryColor, //                   <--- border color
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: constants.kPrimaryColor.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: child,
    );
  }
}
