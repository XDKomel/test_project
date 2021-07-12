import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:plane_chat/main.dart';
import 'package:plane_chat/shared/constants.dart' as constants;
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  SharedPreferences preferences;
  Function onFinish;
   IntroScreen({Key? key,required this.preferences,required this.onFinish}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState(this.onFinish);
}

class _IntroScreenState extends State<IntroScreen> {
  Function onFinish;
  _IntroScreenState(this.onFinish);
  List<Slide> slides = [];
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: SafeArea(child:

      Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: constants.gradientStart,
                end: constants.gradientEnd,
                colors: [
                  constants.gradientBeginColor,
                  constants.gradientBeginColor,
                  constants.gradientEndColor,
                ],
              )),

          child:IntroSlider(

            onDonePress: (){
              widget.preferences.setInt("splash", 1);
              onFinish.call();
            },
            renderNextBtn: Text(
              "ДАЛЕЕ",
              style: TextStyle(color: Color(0xff5283B7),fontSize: 14),
            ),
              renderSkipBtn: Text(
                "ПРОПУСТИТЬ",
                style: TextStyle(color: Color(0xff5283B7),fontSize: 12),
              ),
              renderPrevBtn: Text(
                "НАЗАД",
                style: TextStyle(color: Color(0xff5283B7),fontSize: 14),
              ),
              renderDoneBtn: Text(
                "НАЧАТЬ",
                style: TextStyle(color: Color(0xff5283B7),fontSize: 14),
              ),



            backgroundColorAllSlides:Colors.transparent,

        scrollPhysics: BouncingScrollPhysics(),
        // List slides
        slides: [Slide(

          backgroundColor: Colors.transparent,
            title:
            "Находите людей с таким же рейсом, что и у вас",
            maxLineTitle: 4,
            styleTitle: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono'),

            marginDescription:
            EdgeInsets.only(left: 0.0, right: 20.0, top: 10.0, bottom: 110.0),
            centerWidget: Container(
                margin: EdgeInsets.only(bottom: 15),
              padding: EdgeInsets.only(bottom: 10),
                width: MediaQuery.of(context).size.width,


                alignment: Alignment.topLeft,
                child:
                Image(image: AssetImage('assets/images/tickets.png'))),

            directionColorBegin: Alignment.topLeft,
            directionColorEnd: Alignment.bottomRight,
            onCenterItemPress: () {},
          ),
      Slide(
        backgroundColor: Colors.transparent,

        title: "Создайте аккаунт и вступите в чат",
        maxLineTitle: 4,
        styleTitle: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),

        centerWidget:  Container(
            width: MediaQuery.of(context).size.width,


            alignment: Alignment.centerRight,
            child:
            Image(image: AssetImage('assets/images/messages1.png'))),
        directionColorBegin: Alignment.topCenter,
        directionColorEnd: Alignment.bottomCenter,
        maxLineTextDescription: 3,
      ),Slide(
            backgroundColor: Colors.transparent,


        title: "Используйте общение с пользой",
            maxLineTitle: 4,
        styleTitle: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
       centerWidget:  Container(
           width: MediaQuery.of(context).size.width,


           alignment: Alignment.centerRight,
           child:
           Image(image: AssetImage('assets/images/message2.png'))),
        directionColorBegin: Alignment.topCenter,
        directionColorEnd: Alignment.bottomCenter,
        maxLineTextDescription: 3,
      ),]))
    ));
  }
}
