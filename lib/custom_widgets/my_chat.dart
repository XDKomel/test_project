import 'package:flutter/material.dart';
import 'package:plane_chat/shared/constants.dart' as constants;

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text('lolokek'),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //
              // ),
              // child: ,
            )
        ),
        buildInput()

      ],
    );
  }


  Widget buildInput() {
    Size size = MediaQuery
        .of(context)
        .size;
    return Container(child: Row(

        children: [

          Container(

            child: Row(
              children: <Widget>[


                Flexible(

                  child: Container(


                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.only(left: 10),

                    child: TextField(
                      keyboardType: TextInputType.text,
                      onSubmitted: (value) {
                        //onSendMessage(textEditingController.text, 0);
                      },

                      style: TextStyle(
                          color: constants.kPrimaryColor, fontSize: 14.0),
                      //controller: textEditingController,
                      decoration: InputDecoration.collapsed(


                        hintText: "Отправить сообщение",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      //focusNode: focusNode,
                    ),
                  ),
                ),

                // Button send message

              ],
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(35)),
                border: Border.all(color: Colors.grey, width: 0.5),
                color: Colors.white),
            width: size.width * 0.75,
            margin: EdgeInsets.all(10),
            height: 50.0,

          ),
          Material(
            child: Container(

              padding: EdgeInsets.only(right: 2),
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(Icons.play_arrow_rounded),
                iconSize: 20,
                onPressed: () {

                },
                color: Colors.white,
              ),
              decoration: BoxDecoration(

                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  border: Border.all(color: Colors.transparent, width: 0.5),
                  color: constants.accentColor),

            ),
            color: Colors.transparent,
          ),

        ]));
  }
  void onSendMessage(String content, int type) {
    FocusManager.instance.primaryFocus!.unfocus();

  }

}
