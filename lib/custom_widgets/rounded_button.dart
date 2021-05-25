import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plane_chat/shared/constants.dart' as constants;

class RoundedButton extends StatelessWidget {
  final String? text;
  final VoidCallback? press;
  final double? textSize;
  final Color color, textColor;
  final bool borders;

  const RoundedButton({
    Key? key,
    this.text,
    this.press,
    this.textSize,
    this.color = constants.accentColor,
    this.textColor = Colors.white,
    this.borders = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // h and w of screen

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: (size.width > 300) ? 300 : size.width * 0.8,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            boxShadow: [
              BoxShadow(
                color: constants.accentColor.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          child: FlatButton(
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: constants.accentColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(60.0)),
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40),
            color: color,
            onPressed: press,
            child: Text(
              text!,
              style: TextStyle(
                color: textColor,
                fontSize: (textSize == null) ? 16 : textSize,
                fontWeight: FontWeight.w700,
              ),
            ).tr(),
          )),
    );
  }
}
