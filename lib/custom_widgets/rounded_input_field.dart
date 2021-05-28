import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:plane_chat/custom_widgets/textfield_container.dart';
import 'package:plane_chat/shared/constants.dart' as constants;


class RoundedInputField extends StatelessWidget {
  final String? hintText;

  final int exactLines;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FocusNode? next;
  final FocusNode? current;
  final bool resizable;
  final double width;
  final TextInputType? keyboard;
  final double maxHeight;
  final int maxCharacters;
  final TextAlign? textAlign;
  const RoundedInputField({
    Key? key,
    this.hintText,
    this.controller,
    this.next,
    this.current,
    this.keyboard,
    this.onChanged,
    this.resizable = false,
    this.exactLines = 1,
    this.width = 0.8,
    this.maxHeight = 0.1,
    this.maxCharacters = 50,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // h and w of screen
    return Container(
      width: (size.width>300)?300:size.width*width,
      child: TextFieldContainer(
        child: ConstrainedBox(

          constraints: BoxConstraints(

            maxHeight: size.height * maxHeight,
          ),
          child: TextFormField(
            controller: controller ,
            keyboardType: keyboard,
            focusNode: current,


            textInputAction: TextInputAction.next,

            onFieldSubmitted: (term){
              _fieldFocusChange(context,current!,next!);
            },

            style: TextStyle(color: Colors.black),


            inputFormatters: <TextInputFormatter>[
             //_mobileFormatter
            ],
            maxLines: resizable ? null : exactLines,
            onChanged: onChanged,

            textAlign: textAlign ?? TextAlign.start,

            decoration: InputDecoration(
              hintStyle: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.grey,
                fontSize: 18,
              ),

              hintText: hintText!.tr(),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    if(nextFocus!=null){
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
    }else{

      currentFocus.unfocus();
    }
  }

}
