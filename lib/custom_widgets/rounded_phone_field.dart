import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:plane_chat/custom_widgets/textfield_container.dart';
import 'package:plane_chat/shared/constants.dart' as constants;






class RoundedPhoneField extends StatelessWidget {
  final String? hintText;

  final int exactLines;
  final ValueChanged<String>? onChanged;
  final FocusNode? next;
  final FocusNode? current;
  final bool resizable;
  final double width;
  final TextInputType? keyboard;
  final double maxHeight;
  final int maxCharacters;
  const RoundedPhoneField({
    Key? key,
    this.hintText,
    this.next,
    this.current,
    this.keyboard,
    this.onChanged,
    this.resizable = false,
    this.exactLines = 1,
    this.width = 0.8,
    this.maxHeight = 0.1,
    this.maxCharacters = 18,
  }) : super(key: key);



  @override
  void initState() {

    current!.addListener(() {


    });
  }


  @override
  Widget build(BuildContext context) {



    var  _mobileFormatter = new MaskTextInputFormatter
      (initialText: "+7 (",mask: '+7 (###) ###-##-##', filter: { "#": RegExp(r'[0-9]') ,
      "@":RegExp(r'[7]')});

    Size size = MediaQuery.of(context).size; // h and w of screen
    return Container(
      width: (size.width>300)?300:size.width*width,
      child: TextFieldContainer(

        child: ConstrainedBox(

          constraints: BoxConstraints(

            maxHeight: size.height * maxHeight,
          ),
          child:
          TextFormField(
            style: TextStyle(color: constants.kPrimaryColor),
            keyboardType: keyboard,
            focusNode: current,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term){
              _fieldFocusChange(context,current!,next!);
            },

            inputFormatters: [_mobileFormatter],
            maxLines: resizable ? null : exactLines,
            onChanged: onChanged,

            decoration: InputDecoration(

              hintStyle: TextStyle(
                fontWeight: FontWeight.normal,
                color: constants.kPrimaryColor,
                fontSize: 18,
              ),

              hintText: "+7 (",
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
