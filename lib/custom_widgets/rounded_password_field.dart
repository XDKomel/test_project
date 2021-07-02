import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:plane_chat/custom_widgets/textfield_container.dart';
import 'package:plane_chat/shared/constants.dart' as constants;



bool hidden = true;




class RoundedPasswordField extends StatefulWidget{
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
  final TextAlign? textAlign;


  const RoundedPasswordField({
    Key? key,
    this.hintText,
    this.textAlign,
    this.next,
    this.current,
    this.keyboard,
    this.onChanged,
    this.resizable = false,
    this.exactLines = 1,
    this.width = 0.8,
    this.maxHeight = 0.1,
    this.maxCharacters = 50,
  }):super(key:key);

  @override
  State<StatefulWidget> createState() => _RoundedPasswordField(
    key: key,
    hintText: this.hintText,
    next: next,
    current: current,
    keyboard: keyboard,
    onChanged: onChanged,
    resizable: resizable,
    exactLines: exactLines,
    width: width,
    maxHeight: maxHeight,
    maxCharacters: maxCharacters

  );

}

class _RoundedPasswordField extends State<RoundedPasswordField> {
   String? hintText;
   Key? key;
   int exactLines;
   ValueChanged<String>? onChanged;
   FocusNode? next;
   FocusNode? current;
   bool resizable;
   double width;
   TextInputType? keyboard;
   double maxHeight;
   int maxCharacters;
   final TextAlign? textAlign;


   _RoundedPasswordField({
     this.textAlign,
    required this.key,
    required this.hintText,
    required this.next,
    required this.current,
    required this.keyboard,
    required this.onChanged,
    this.resizable = false,
    this.exactLines = 1,
    this.width = 0.8,
    this.maxHeight = 0.1,
    this.maxCharacters = 50,
  });

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
          child:
          TextFormField(
            style: TextStyle(color: Colors.black),
            obscureText: hidden,
            keyboardType: keyboard,
            focusNode: current,
            textAlign: textAlign ?? TextAlign.start,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term){
              _fieldFocusChange(context,current!,next!);
            },

            maxLines: resizable ? null : exactLines,
            onChanged: onChanged,


            decoration: InputDecoration(

              suffixIcon: IconButton(

                onPressed: (){

                      hidden = !hidden;
                      setState(() {

                      });

                },
                icon:Icon((hidden)?Icons.visibility_off:Icons.visibility),
                color: Colors.black,
              ),

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
