import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:plane_chat/shared/constants.dart' as constants;
import 'package:easy_localization/easy_localization.dart';
import 'package:plane_chat/models/SessionKeeper.dart';
import 'package:plane_chat/models/authorities.dart';

String streamID='';

class CommentField extends StatefulWidget {
  List<String>? initBanMessage;
  List<String>? initBanUsers;
  Function? onMessageSend;
  String? streamId;
  String? token;

  CommentField(
      {this.streamId, this.initBanUsers, this.initBanMessage, this.onMessageSend, this.token});

  @override
  State<StatefulWidget> createState() =>
      _CommentField(token: this.token,
          streamId: streamId,
          banUsers: initBanUsers,
          banMessages: initBanMessage,
          onMessageSend: onMessageSend);


}

class _CommentField extends State<CommentField> {

  Function? onMessageSend;
  List<String>? banUsers;

  List<String>? banMessages;

  var avatarsList = [
    'android/assets/images/1.png',
    'android/assets/images/2.png',
    'android/assets/images/3.png'];


  String? token;
  final _random = new Random();
  String? streamId;
  Map<String, String> avatars = {};

  _CommentField(
      {this.streamId, this.banUsers, this.banMessages, this.onMessageSend, this.token});

  final TextEditingController textEditingController = TextEditingController();
  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  // @override
  // void initState() {
  //   streamID = this.streamId!;
  // }

  late Dialog banUserDialog;
  late Dialog banMessageDialog;
  late Dialog banComplaintDialog;

  // void showComplaintUserDialog({required BuildContext context,
  //   required String uid,
  //
  //   String? streamId,
  //   String? adminEmail,
  //   String? userEmail}) {
  //   banComplaintDialog = Dialog(
  //     shape: RoundedRectangleBorder(
  //
  //         borderRadius: BorderRadius.circular(12.0)), //this right here
  //
  //     child: Container(
  //
  //       height: 270.0,
  //       width: 300.0,
  //
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //
  //         children: <Widget>[
  //
  //           Padding(
  //
  //             padding: EdgeInsets.only(left: 5, right: 5, top: 15),
  //             child: Text(
  //               (!SessionKeeper.user!.authorities.contains(Authority.ADMIN))
  //                   ? "complain".tr()
  //                   : "Подать жалобу", style: TextStyle(color: Colors.black),),
  //           ),
  //
  //           Padding(
  //             padding: EdgeInsets.only(
  //                 left: 15, right: 15, top: 10, bottom: 10),
  //
  //             child: Text(
  //               "complainmsg".tr(),
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //
  //                   fontSize: 13,
  //                   color: Colors.black,
  //                   fontWeight: FontWeight.normal),
  //
  //             ),
  //           ),
  //
  //           Padding(
  //               padding: EdgeInsets.only(top: 30.0)
  //           ),
  //
  //
  //           FlatButton(
  //
  //               onPressed: () async {
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text(
  //                 (!SessionKeeper.user!.authorities.contains(Authority.ADMIN))
  //                     ? "complain".tr()
  //                     : "Подать жалобу",
  //                 style: TextStyle(
  //                     color: Colors.red,
  //                     fontSize: 16.0),
  //               )
  //           ),
  //
  //           FlatButton(onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //
  //               child: Text(
  //                 "cancel".tr(),
  //                 style: TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 16.0),
  //               ))
  //
  //         ],
  //       ),
  //     ),
  //   );
  //   showDialog(context: context,
  //       builder: (BuildContext context) => banComplaintDialog);
  // }


  // void showBanUserDialog({required BuildContext context,
  //    String? uid,
  //
  //    String? streamId,
  //    String? adminEmail,
  //    String? userEmail}) {
  //   banUserDialog = Dialog(
  //     shape: RoundedRectangleBorder(
  //
  //         borderRadius: BorderRadius.circular(12.0)), //this right here
  //
  //     child: Container(
  //
  //       height: 270.0,
  //       width: 300.0,
  //
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //
  //         children: <Widget>[
  //
  //           Padding(
  //
  //             padding: EdgeInsets.only(left: 5, right: 5, top: 15),
  //             child: Text(
  //               (!SessionKeeper.user!.authorities.contains(Authority.ADMIN))
  //                   ? "complain".tr()
  //                   : "Заблокировать", style: TextStyle(color: Colors.black),),
  //           ),
  //
  //           Padding(
  //             padding: EdgeInsets.only(
  //                 left: 15, right: 15, top: 10, bottom: 10),
  //
  //             child: Text(
  //               "reporttext".tr(),
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //
  //                   fontSize: 13,
  //                   color: Colors.black,
  //                   fontWeight: FontWeight.normal),
  //
  //             ),
  //           ),
  //
  //           Padding(
  //               padding: EdgeInsets.only(top: 30.0)
  //           ),
  //
  //
  //           FlatButton(
  //
  //               onPressed: () async {
  //                 await banUser(
  //                   streamId: streamId,
  //                   userId: uid,
  //
  //
  //                 );
  //                 setState(() {
  //
  //                 });
  //
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text(
  //                 (!SessionKeeper.user!.authorities.contains(Authority.ADMIN))
  //                     ? "complain".tr()
  //                     : "Заблокировать",
  //                 style: TextStyle(
  //                     color: Colors.red,
  //                     fontSize: 16.0),
  //               )
  //           ),
  //
  //           FlatButton(onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //
  //               child: Text(
  //                 "cancel".tr(),
  //                 style: TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 16.0),
  //               ))
  //
  //         ],
  //       ),
  //     ),
  //   );
  //   showDialog(
  //       context: context, builder: (BuildContext context) => banUserDialog);
  // }

  // void showBanMessageDialog({required BuildContext context,
  //   String? uid,
  //   List<String>? banUsers,
  //    String? streamId,
  //    String? adminEmail,
  //    String? userEmail,
  //    String? messageId}) {
  //   banMessageDialog = Dialog(
  //     shape: RoundedRectangleBorder(
  //
  //         borderRadius: BorderRadius.circular(12.0)), //this right here
  //
  //     child: Container(
  //
  //       height: 270.0,
  //       width: 300.0,
  //
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //
  //         children: <Widget>[
  //
  //           Padding(
  //
  //             padding: EdgeInsets.only(left: 5, right: 5, top: 15),
  //             child: Text(
  //               "deletemsg".tr(), style: TextStyle(color: Colors.black),),
  //           ),
  //
  //           Padding(
  //             padding: EdgeInsets.only(
  //                 left: 15, right: 15, top: 10, bottom: 10),
  //
  //             child: Text(
  //               "bantext".tr(),
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //
  //                   fontSize: 13,
  //                   color: Colors.black,
  //                   fontWeight: FontWeight.normal),
  //
  //             ),
  //           ),
  //
  //           Padding(
  //               padding: EdgeInsets.only(top: 30.0)
  //           ),
  //
  //
  //           FlatButton(
  //
  //               onPressed: () async {
  //                 await banMessage(
  //                     uid!, messageId!
  //                 );
  //
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text("deletemsg".tr(),
  //                 style: TextStyle(
  //                     color: Colors.red,
  //                     fontSize: 16.0),
  //               )
  //           ),
  //
  //           FlatButton(onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //
  //               child: Text(
  //                 "cancel".tr(),
  //                 style: TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 16.0),
  //               ))
  //
  //         ],
  //       ),
  //     ),
  //   );
  //   showDialog(
  //       context: context, builder: (BuildContext context) => banMessageDialog);
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    //print("List: "+SessionKeeper.user.authorities.toString());
    return SingleChildScrollView(

        child: Container(

            width: double.infinity,
            alignment: Alignment.centerRight,

            child: WillPopScope(

              onWillPop: () async {
                await Future.delayed(Duration(seconds: 1));
                return Future.error('Error from return');
              },
              child: Stack(

                alignment: Alignment.centerRight,
                children: <Widget>[

                  Column(

                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      SizedBox(height: 10,),

                      buildInput(),

                      Container(
                          width: size.width,

                          child: StreamBuilder(

                            stream: FirebaseFirestore.instance
                                .collection('streams').doc(streamId).collection(
                                'messages')
                                .orderBy('time', descending: true)
                                .snapshots(),

                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(

                                    child: Container(

                                        margin: EdgeInsets.only(top: 15),
                                        child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<
                                                Color>(constants.kPrimaryColor))
                                    ));
                              } else {
                                var messageList = [];
                                //listMessage = snapshot.data!.;

                                listMessage.forEach((element) {
                                  Timestamp time = element.get('time');


                                  if (!banUsers!.contains(
                                      element.get('user_id')) &&
                                      !banMessages!.contains(
                                          element.get('user_id')
                                              + time.millisecondsSinceEpoch
                                              .toString())) {
                                    messageList.add(element);
                                  }
                                });

                                return Container(

                                    alignment: Alignment.centerRight,
                                    height: size.height * 0.925 - 144 -
                                        (9.0 / 16.0) * size.width,
                                    // - (16.0/9.0)*size.width

                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        child: ListView.builder(

                                          padding: EdgeInsets.all(10.0),

                                          itemBuilder: (context, index) =>
                                              buildItem(
                                                  index, messageList[index]),
                                          itemCount: messageList.length,
                                          reverse: false,
                                          controller: listScrollController,

                                        )));
                              }
                            },
                          )),


                    ],

                  )
                ],


              ),

            )


        ));
  }


  Widget buildItem(int index, DocumentSnapshot document) {
    String uid = document.get('user_id');
    String name = document.get('username');
    Timestamp time = document.get('time');
    String messageId = uid + time.millisecondsSinceEpoch.toString();

    String timeLabel = time
        .toDate()
        .hour
        .toString() + ":";
    if (time
        .toDate()
        .minute < 10) {
      timeLabel += "0";
    }
    timeLabel += time
        .toDate()
        .minute
        .toString();

    if (!avatars.containsKey(name)) {
      avatars[name] = avatarsList[_random.nextInt(avatarsList.length)];
    }


    return Row(

        mainAxisAlignment: (uid == SessionKeeper.user!.uid)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: <Widget>[
          if(uid != SessionKeeper.user!.uid)Container(
            margin: EdgeInsets.only(right: 5),
            width: 35,
            height: 35
            ,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),

              image: DecorationImage(
                  scale: 0.6,
                  image: ExactAssetImage('assets/images/image1.png'),
                  //[ExactAssetImage('android/assets/images/woman.png'),ExactAssetImage('android/assets/images/man.png'),ExactAssetImage('android/assets/images/woman2.png')][_random.nextInt(3)],
                  fit: BoxFit.contain
              ),
            ),
          ),
          Container(

            child:

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // (uid!=SessionKeeper.user.uid)?CrossAxisAlignment.start:CrossAxisAlignment.end,
              children: [

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [


                      Text(

                        name,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Color(0xff7C7C7C), fontSize: 10),
                      ),

                      if(uid != SessionKeeper.user!.uid)Container(
                          width: 40,
                          height: 40,

                          child: PopupMenuButton<String>(

                            elevation: 1,
                            offset: Offset(0, -25),


                            onSelected: (String result) {
                              if (result == "Complaint") {
                                // showComplaintUserDialog(
                                //
                                //   context: context,
                                //   uid: uid,
                                //   streamId: streamId,
                                //
                                //
                                // );
                                setState(() {

                                });
                              }

                              if (result == "Ban") {
                                // showBanUserDialog(
                                //
                                //   context: context,
                                //   uid: uid,
                                //   streamId: streamId,
                                //
                                //
                                // );
                                setState(() {

                                });
                              }
                              if (result == "Delete") {
                                // showBanMessageDialog(
                                //   context: context,
                                //   messageId: messageId,
                                //   uid: uid,
                                //
                                //
                                // );
                                setState(() {

                                });
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[

                              PopupMenuItem<String>(
                                height: 25,

                                value: "Complaint",
                                child: Container(
                                    width: 120,
                                    child: Text(
                                      (!SessionKeeper.user!.authorities.contains(
                                          Authority.ADMIN))
                                          ? "complain".tr()
                                          : "Подать жалобу",
                                      style: TextStyle(fontSize: 14),)),
                              ),
                              PopupMenuItem<String>(
                                height: 25,

                                value: "Ban",
                                child: Container(
                                    width: 120,
                                    child: Text(
                                      (!SessionKeeper.user!.authorities
                                          .contains(Authority.ADMIN)) ? "ban"
                                          .tr() : "Заблокировать",
                                      style: TextStyle(fontSize: 14),)),
                              ),
                              PopupMenuItem<String>(
                                height: 25,
                                value: "Delete",
                                child: Container(
                                    width: 120,
                                    child: Text("deletemsg".tr(),
                                      style: TextStyle(fontSize: 14),)),
                              ),


                            ],
                          ))
                    ]
                ),
                (uid == SessionKeeper.user!.uid)
                    ? SizedBox(height: 15,)
                    : SizedBox(height: 5,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // if((uid==SessionKeeper.user.uid))Text(
                    //   timeLabel,
                    //   style: TextStyle(color: Color(0xff7C7C7C),fontSize: 8),
                    // ),
                    Container(

                        child: Flexible(child: Text(

                          document.get('content'),
                          style: TextStyle(color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                        ))),
                    //if((uid!=SessionKeeper.user.uid))
                    Text(
                      timeLabel,
                      style: TextStyle(color: Color(0xff7C7C7C), fontSize: 8),
                    ),

                  ],
                ),


              ],
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 240.0,

            decoration: BoxDecoration(
                color: Color(0xffF4F4F6),
                borderRadius: BorderRadius.circular(12.0)),
            margin: EdgeInsets.only(
              bottom: 10.0,
              right: (uid != SessionKeeper.user!.uid) ? 30 : 0,
            ),
          ),


          if(uid == SessionKeeper.user!.uid)Container(
            //padding: EdgeInsets.only(top: 5),
            margin: EdgeInsets.only(left: 5),
            width: 35,
            height: 35,
            decoration: BoxDecoration(

              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),

              image: DecorationImage(
                  scale: 0.6,

                  image: ExactAssetImage('android/assets/images/image1.png'),
                  //[ExactAssetImage('android/assets/images/woman.png'),ExactAssetImage('android/assets/images/man.png'),ExactAssetImage('android/assets/images/woman2.png')][_random.nextInt(3)],
                  fit: BoxFit.contain
              ),
            ),
          ),

        ]);
  }


  //bans all messages from user


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
                      controller: textEditingController,
                      decoration: InputDecoration.collapsed(


                        hintText: "Отправить сообщение",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      focusNode: focusNode,
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
                onPressed: () => onSendMessage(textEditingController.text, 0),
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
    onMessageSend!.call();
    print(SessionKeeper.user!.uid);
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseFirestore.instance.
      collection('streams').doc(streamId).collection('messages')
          .doc(DateTime
          .now()
          .millisecondsSinceEpoch
          .toString());

      var counterRef = FirebaseFirestore.instance.collection('streams')
          .doc(streamId)
          .collection('counts')
          .doc('messages');

      counterRef.update({'count': FieldValue.increment(1)});


      print("NAME " + streamId!);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'content': content,
            'time': FieldValue.serverTimestamp(),
            //Timestamp.fromDate(DateTime.now()),
            'user_id': SessionKeeper.user!.uid,
            'username': SessionKeeper.user!.uid,


          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {

    }
  }

  //
  // Future<void> banUser({ String? userId,  String? streamId}) async {
  //   if (!SessionKeeper.user!.authorities.contains(Authority.ADMIN)) {
  //     var documentReference = FirebaseFirestore.instance.collection('streams')
  //         .doc(streamId)
  //         .collection('blacklist')
  //         .doc('local').collection('users')
  //         .doc(SessionKeeper.user!.uid)
  //         .collection('banned_users')
  //         .doc(DateTime
  //         .now()
  //         .millisecondsSinceEpoch
  //         .toString());
  //
  //     await FirebaseFirestore.instance.runTransaction((transaction) async {
  //       transaction.set(
  //         documentReference,
  //         {
  //           'uid': userId
  //         },
  //       );
  //     });
  //     print(documentReference.toString());
  //   } else {
  //     var documentReference = FirebaseFirestore.instance.collection('streams')
  //         .doc(streamId)
  //         .collection('blacklist')
  //         .doc('global').collection('banned_users')
  //
  //         .doc(DateTime
  //         .now()
  //         .millisecondsSinceEpoch
  //         .toString());
  //
  //     //await APIRequests().changeUserAccess(this.token, userId);
  //
  //
  //     await FirebaseFirestore.instance.runTransaction((transaction) async {
  //       transaction.set(
  //         documentReference,
  //         {
  //           'uid': userId
  //         },
  //       );
  //     });
  //     print(documentReference.toString());
  //   }
  //
  //   banUsers!.add(userId!);
  //   setState(() {
  //
  //   });
  // }

//bans only one message from user
//   Future<void> banMessage(String userId, String messageId) async {
//     if (!SessionKeeper.user!.authorities.contains(Authority.ADMIN)) {
//       var documentReference = FirebaseFirestore.instance.collection('streams')
//           .doc(streamId)
//           .collection('blacklist')
//           .doc('local').collection('users')
//           .doc(SessionKeeper.user!.uid)
//           .collection('messages')
//           .doc(DateTime
//           .now()
//           .millisecondsSinceEpoch
//           .toString());
//
//       await FirebaseFirestore.instance.runTransaction((transaction) async {
//         transaction.set(
//           documentReference,
//           {
//             'uid': messageId
//           },
//         );
//       });
//       print(documentReference.toString());
//     } else {
//       print("ADMIN");
//       var documentReference = FirebaseFirestore.instance.collection('streams')
//           .doc(streamId)
//           .collection('blacklist')
//           .doc('global').collection('banned_messages')
//
//           .doc(DateTime
//           .now()
//           .millisecondsSinceEpoch
//           .toString());
//
//       await FirebaseFirestore.instance.runTransaction((transaction) async {
//         transaction.set(
//           documentReference,
//           {
//             'uid': messageId
//           },
//         );
//       });
//       print(documentReference.toString());
//     }
//
//     banMessages!.add(messageId);
//     setState(() {
//
//     });
//   }


}


// List<String> bannedMessages() {
//   List<String> users = [];
//
//   FirebaseFirestore.instance
//       .collection('streams')
//       .doc(streamID)
//       .collection('blacklist')
//       .doc('local').collection('users')
//       .doc(SessionKeeper.user!.uid)
//       .collection('messages').get().then((snapshot) {
//     print("messages len: " + snapshot.docs.length.toString());
//     snapshot.docs.forEach((result) {
//       users.add(result.get('uid'));
//     });
//   });
//
//
//   FirebaseFirestore.instance.collection('streams')
//       .doc(streamID)
//       .collection('blacklist')
//       .doc('global')
//       .collection('banned_messages').get().then((snapshot) {
//     snapshot.docs.forEach((result) {
//       users.add(result.get('uid'));
//     });
//   });
//
//
//   print("Messages: " + users.toString());
//   return users;
// }

// List<String> bannedUsers() {
//   List<String> users = [];
//
//   FirebaseFirestore.instance
//       .collection('streams')
//       .doc(streamID)
//       .collection('blacklist')
//       .doc('local').collection('users')
//       .doc(SessionKeeper.user!.uid)
//       .collection('banned_users').get().then((snapshot) {
//     print("users len: " + snapshot.docs.length.toString());
//     snapshot.docs.forEach((result) {
//       users.add(result.get('uid'));
//     });
//   });
//
//
//   FirebaseFirestore.instance.collection('streams')
//       .doc(streamID)
//       .collection('blacklist')
//       .doc('global')
//       .collection('banned_users').get().then((snapshot) {
//     snapshot.docs.forEach((result) {
//       users.add(result.get('uid'));
//     });
//   });
//
//
//   print("Users: " + users.toString());
//   return users;
// }