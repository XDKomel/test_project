import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plane_chat/models/UserData.dart';
import 'package:plane_chat/screens/home/profile.dart';

import 'package:plane_chat/shared/constants.dart' as constants;
import 'package:easy_localization/easy_localization.dart';
import 'package:plane_chat/models/SessionKeeper.dart';
import 'package:plane_chat/models/authorities.dart';

String streamID = '';
typedef void IntCallback(int id);

class CommentField extends StatefulWidget {
  List<String> initBanMessage;
  List<String> initBanUsers;
  Function? onMessageSend;
  String streamId;
  String display_id;
  String? token;
  bool? joined=false;

  final IntCallback onPeopleChanged;

  CommentField(
      {required this.streamId,
        required this.display_id,
      required this.initBanUsers,
      required this.initBanMessage,
        required this.onPeopleChanged,
      this.onMessageSend,
      this.token,
      this.joined});

  @override
  State<StatefulWidget> createState() => _CommentField(
    onPeopleChanged: onPeopleChanged,
      token: this.token,
      streamId: streamId,
      display_id: display_id,
      banUsers: initBanUsers,
      banMessages: initBanMessage,
      onMessageSend: onMessageSend,
      joined: joined);
}

class _CommentField extends State<CommentField> {
  Function? onMessageSend;
  final IntCallback onPeopleChanged;

  List<String> banUsers = new List.from([]);

  List<String> banMessages = new List.from([]);

  var avatarsList = [
    'android/assets/images/1.png',
    'android/assets/images/2.png',
    'android/assets/images/3.png'
  ];

  String? token;
  final _random = new Random();
  String streamId;
  String display_id;
  int numOfPeople=0;
  bool? joined=false;
  Map<String, String> avatars = {};

  _CommentField(
      {required this.streamId,
        required this.display_id,
      required this.banUsers,
      required this.banMessages,
        required this.onPeopleChanged,
      this.onMessageSend,
      this.token,
      this.joined});

  final TextEditingController textEditingController = TextEditingController();
  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    streamID = this.streamId;
    listScrollController.addListener(_scrollListener);
  }

  late Dialog banUserDialog;
  late Dialog banMessageDialog;
  late Dialog banComplaintDialog;
  int _limit = 20;
  int _limitIncrement = 20;

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void showComplaintUserDialog(
      {required BuildContext context,
      required String uid,
      String? streamId,
      String? adminEmail,
      String? userEmail}) {
    banComplaintDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here

      child: Container(
        height: 270.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5, top: 15),
              child: Text(
                (!SessionKeeper.user.authorities.contains(Authority.ADMIN))
                    ? constants.COMPLAIN.tr()
                    : "Подать жалобу",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              child: Text(
                constants.COMPLAINMENT_MSG.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 30.0)),
            FlatButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: Text(
                  (!SessionKeeper.user.authorities.contains(Authority.ADMIN))
                      ? constants.COMPLAIN.tr()
                      : "Подать жалобу",
                  style: TextStyle(color: Colors.red, fontSize: 20),
                )),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  constants.CANCEL.tr(),
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ))
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) => banComplaintDialog);
  }

  void showBanUserDialog(
      {required BuildContext context,
      String? uid,
      String? streamId,
      String? adminEmail,
      String? userEmail}) {
    banUserDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here

      child: Container(
        height: 270.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5, top: 15),
              child: Text(
                (!SessionKeeper.user.authorities.contains(Authority.ADMIN))
                    ? constants.BAN_USER_TEXT.tr()
                    : "Заблокировать",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              child: Text(
                constants.BAN_USER_MSG.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 30.0)),
            FlatButton(
                onPressed: () async {
                  await banUser(
                    streamId: streamId,
                    userId: uid,
                  );
                  setState(() {});

                  Navigator.of(context).pop();
                },
                child: Text(
                  (!SessionKeeper.user.authorities.contains(Authority.ADMIN))
                      ? constants.BAN.tr()
                      : "Заблокировать",
                  style: TextStyle(color: Colors.red, fontSize: 20),
                )),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  constants.CANCEL.tr(),
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ))
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => banUserDialog);
  }

  void showBanMessageDialog(
      {required BuildContext context,
      String? uid,
      List<String>? banUsers,
      String? streamId,
      String? adminEmail,
      String? userEmail,
      String? messageId}) {
    banMessageDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here

      child: Container(
        height: 270.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5, top: 15),
              child: Text(
                constants.MSG_DELETING.tr(),
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              child: Text(
                constants.BAN_TEXT.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 30.0)),
            FlatButton(
                onPressed: () async {
                  await banMessage(uid!, messageId!);

                  Navigator.of(context).pop();
                },
                child: Text(
                  constants.DELETE_MSG.tr(),
                  style: TextStyle(color: Colors.red, fontSize: 20),
                )),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  constants.CANCEL.tr(),
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ))
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => banMessageDialog);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    joined = widget.joined;
    //print("List: "+SessionKeeper.user.authorities.toString());
    return Container(
        width: double.infinity,
        alignment: Alignment.centerRight,
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                      width: size.width,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('streams')
                            .doc(streamId)
                            .collection('messages')
                            .orderBy('time', descending: true)
                            .limit(_limit)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                                child: Container(
                                    margin: EdgeInsets.only(top: 15),
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                constants.kPrimaryColor))));
                          } else {
                            var messageList = [];
                            listMessage = snapshot.data!.docs;

                            listMessage.forEach((element) {
                              Timestamp time = element.get('time');

                              if (!banUsers
                                      .contains(element.get('user_id')) &&
                                  !banMessages.contains(
                                      element.get('user_id') +
                                          time.millisecondsSinceEpoch
                                              .toString())) {
                                messageList.add(element);
                              }

                              //messageList.add(element);
                            });
                            //messageList = List.from(messageList.reversed);
                            // double height = size.height * 0.925 - 144 -
                            //     (9.0 / 16.0) * size.width;
                            return Container(
                                alignment: Alignment.centerRight,
                                // height: height >0? height ,
                                // // - (16.0/9.0)*size.width

                                child: Container(
                                    alignment: Alignment.centerRight,
                                    child: ListView.builder(
                                      padding: EdgeInsets.all(10.0),
                                      itemBuilder: (context, index) =>
                                          buildItem(
                                              index, messageList[index]),
                                      itemCount: messageList.length,
                                      reverse: true,
                                      shrinkWrap: true,
                                      controller: listScrollController,
                                    )));
                          }
                        },
                      )),
                ),
                if(joined == true) buildInput()
                else buildJoinPanel()
              ],
            )
          ],
        ));
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    String uid = document.get('user_id') ?? "";
    String name = document.get('username') ?? "";
    Timestamp time = document.get('time');
    String messageId = uid + time.millisecondsSinceEpoch.toString();

    String timeLabel = time.toDate().hour.toString() + ":";
    if (time.toDate().minute < 10) {
      timeLabel += "0";
    }
    timeLabel += time.toDate().minute.toString();

    if (!avatars.containsKey(name)) {
      avatars[name] = avatarsList[_random.nextInt(avatarsList.length)];
    }

    return Row(
        mainAxisAlignment: (uid == SessionKeeper.user.uid)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: <Widget>[
          if (uid != SessionKeeper.user.uid)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile(uid: uid)),
                );
              },
              child: Container(
                margin: EdgeInsets.only(right: 5),
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  image: DecorationImage(
                      scale: 0.6,
                      image: ExactAssetImage('assets/images/image1.png'),
                      //[ExactAssetImage('android/assets/images/woman.png'),ExactAssetImage('android/assets/images/man.png'),ExactAssetImage('android/assets/images/woman2.png')][_random.nextInt(3)],
                      fit: BoxFit.contain),
                ),
              ),
            ),
          Container(
            child: Column(
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
                            fontWeight: FontWeight.bold,
                            color: (uid != SessionKeeper.user.uid)
                                ? Color(0xff7C7C7C)
                                : Colors.white,
                            fontSize: 18),
                      ),
                      if (uid != SessionKeeper.user.uid)
                        Container(
                            width: 40,
                            height: 40,
                            child: PopupMenuButton<String>(
                              elevation: 1,
                              offset: Offset(0, -25),
                              onSelected: (String result) {
                                if (result == "Complaint") {
                                  showComplaintUserDialog(
                                    context: context,
                                    uid: uid,
                                    streamId: streamId,
                                  );
                                  setState(() {});
                                }

                                if (result == "Ban") {
                                  showBanUserDialog(
                                    context: context,
                                    uid: uid,
                                    streamId: streamId,
                                  );
                                  setState(() {});
                                }
                                if (result == "Delete") {
                                  showBanMessageDialog(
                                    context: context,
                                    messageId: messageId,
                                    uid: uid,
                                  );
                                  setState(() {});
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  height: 25,
                                  value: "Complaint",
                                  child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 5),

                                      width: 120,
                                      child: Text(
                                        (!SessionKeeper.user.authorities
                                                .contains(Authority.ADMIN))
                                            ? constants.COMPLAIN.tr()
                                            : "Подать жалобу",
                                        style: TextStyle(fontSize: 14),
                                      )),
                                ),
                                PopupMenuDivider(
                                  height: 2,
                                ),
                                PopupMenuItem<String>(
                                  height: 25,
                                  value: "Ban",
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                      width: 120,
                                      child: Text(
                                        (!SessionKeeper.user.authorities
                                                .contains(Authority.ADMIN))
                                            ? constants.BAN.tr()
                                            : "Заблокировать",
                                        style: TextStyle(fontSize: 14),
                                      )),
                                ),
                                    PopupMenuDivider(
                                      height: 2,
                                    ),
                                PopupMenuItem<String>(
                                  height: 25,
                                  value: "Delete",
                                  child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 5),

                                      width: 120,
                                      child: Text(
                                        constants.DELETE_MSG.tr(),
                                        style: TextStyle(fontSize: 14),
                                      )),
                                ),
                              ],
                            ))
                    ]),
                (uid == SessionKeeper.user.uid)
                    ? SizedBox(
                        height: 15,
                      )
                    : SizedBox(
                        height: 5,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // if((uid==SessionKeeper.user.uid))Text(
                    //   timeLabel,
                    //   style: TextStyle(color: Color(0xff7C7C7C),fontSize: 8),
                    // ),
                    Container(
                        child: Flexible(
                            child: Text(
                      document.get('content'),
                      style: TextStyle(
                          color: (uid != SessionKeeper.user.uid)
                              ? Colors.black
                              : Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.normal),
                    ))),
                    //if((uid!=SessionKeeper.user.uid))
                    Text(
                      timeLabel,
                      style: TextStyle(
                          color: (uid != SessionKeeper.user.uid)
                              ? Color(0xff7C7C7C)
                              : Colors.white,
                          fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 240.0,
            decoration: BoxDecoration(
                color: (uid != SessionKeeper.user.uid)
                    ? Color(0xffF4F4F6)
                    : constants.accentColor,
                borderRadius: BorderRadius.circular(12.0)),
            margin: EdgeInsets.only(
              bottom: 10.0,
              right: (uid != SessionKeeper.user.uid) ? 30 : 0,
            ),
          ),
          if (uid == SessionKeeper.user.uid)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile(uid: uid)),
                );
              },
              child: Container(
                //padding: EdgeInsets.only(top: 5),
                margin: EdgeInsets.only(left: 5),
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  image: DecorationImage(
                      scale: 0.6,
                      image: ExactAssetImage('assets/images/image1.png'),
                      //[ExactAssetImage('android/assets/images/woman.png'),ExactAssetImage('android/assets/images/man.png'),ExactAssetImage('android/assets/images/woman2.png')][_random.nextInt(3)],
                      fit: BoxFit.contain),
                ),
              ),
            ),
        ]);
  }

  //bans all messages from user

  Widget buildInput() {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.only(bottom: 5),
        child: Row(children: [
      Expanded(
        child: Container(
          constraints: BoxConstraints(minHeight: 50, maxHeight: 300),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.only(left: 10),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    onSubmitted: (value) {
                      //onSendMessage(textEditingController.text, 0);
                    },
                    minLines: 1,
                    maxLines: 8,
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                    controller: textEditingController,
                    decoration: InputDecoration.collapsed(
                      hintText: "Отправить сообщение",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                    focusNode: focusNode,
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(35)),
              border: Border.all(color: Colors.grey, width: 0.5),
              color: Colors.white),
          width: size.width * 0.75,
          margin: EdgeInsets.all(10),
        ),
      ),

          Container(
            padding: EdgeInsets.only(right: 10),
          child: FloatingActionButton(
              onPressed: () {
                onSendMessage(textEditingController.text, 0);
              },
            splashColor: Colors.blueAccent,
              child: const Icon(Icons.send),
              backgroundColor: constants.accentColor,

            ),
          ),
      // Container(
      //   padding: EdgeInsets.only(right: 10),
      //   child: Material(
      //     color: Colors.transparent,
      //    // borderRadius: BorderRadius.circular(20),
      //     child: InkWell(
      //       customBorder: new CircleBorder(),
      //       splashColor: Colors.red,
      //       child: Container(
      //         alignment: Alignment.center,
      //         child: IconButton(
      //           icon: Icon(Icons.send_outlined),
      //           iconSize: 20,
      //           onPressed: () => onSendMessage(textEditingController.text, 0),
      //           color: Colors.white,
      //           splashColor: Colors.greenAccent,
      //           highlightColor: Colors.orange,
      //         ),
      //         // decoration: BoxDecoration(
      //         //     borderRadius: BorderRadius.all(Radius.circular(60)),
      //         //     border: Border.all(color: Colors.transparent, width: 0.5),
      //         //     color: constants.accentColor),
      //       ),
      //     ),
      //   ),
      // )
    ]));
  }
  Widget buildJoinPanel() {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.only(bottom: 5, left: 2, right: 2),
        child: Row(children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: constants.accentColor
                ),
                constraints: BoxConstraints(minHeight: 50, maxHeight: 300),
                child: TextButton(
                  onPressed: () async {
                      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection("flights").doc(streamId).set({
                        'id': streamId,
                        'display_id': display_id
                      });
                      joined = true;
                      widget.joined = true;
                      await FirebaseFirestore.instance.collection('flights').doc(streamId).get().then((doc) {
                        int num = doc.get('peopleInChat') + 1;
                        FirebaseFirestore.instance.collection('flights').doc(streamId).update({
                          'peopleInChat': num
                        });
                        onPeopleChanged(num);
                      });


                  },
                  child: const Text('Вступить в чат?', style: TextStyle(fontSize: 20, color: Colors.white),),
                ),

                ),
            )
            ),
          
        ]));
  }
  void onSendMessage(String content, int type) {
    //FocusManager.instance.primaryFocus!.unfocus();
    //onMessageSend!.call();
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('streams')
          .doc(streamId)
          .collection('messages')
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      // var counterRef = FirebaseFirestore.instance
      //     .collection('streams')
      //     .doc(streamId)
      //     .collection('counts')
      //     .doc('messages');

      //counterRef.update({'count': FieldValue.increment(1)});


      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'content': content,
            'time': FieldValue.serverTimestamp(),
            //Timestamp.fromDate(DateTime.now()),
            'user_id': SessionKeeper.user.uid,
            'username': SessionKeeper.user.name,
          },
        );
      });

      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {}
  }

  Future<void> banUser({String? userId, String? streamId}) async {
    if (!SessionKeeper.user.authorities.contains(Authority.ADMIN)) {
      var documentReference = FirebaseFirestore.instance
          .collection('streams')
          .doc(streamId)
          .collection('blacklist')
          .doc('local')
          .collection('users')
          .doc(SessionKeeper.user.uid)
          .collection('banned_users')
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {'uid': userId},
        );
      });
      print(documentReference.toString());
    } else {
      var documentReference = FirebaseFirestore.instance
          .collection('streams')
          .doc(streamId)
          .collection('blacklist')
          .doc('global')
          .collection('banned_users')
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      //await APIRequests().changeUserAccess(this.token, userId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {'uid': userId},
        );
      });
      print(documentReference.toString());
    }

    banUsers.add(userId!);
    setState(() {});
  }

//bans only one message from user
  Future<void> banMessage(String userId, String messageId) async {
    if (!SessionKeeper.user.authorities.contains(Authority.ADMIN)) {
      var documentReference = FirebaseFirestore.instance
          .collection('streams')
          .doc(streamId)
          .collection('blacklist')
          .doc('local')
          .collection('users')
          .doc(SessionKeeper.user.uid)
          .collection('messages')
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {'uid': messageId},
        );
      });
      print(documentReference.toString());
    } else {
      print("ADMIN");
      var documentReference = FirebaseFirestore.instance
          .collection('streams')
          .doc(streamId)
          .collection('blacklist')
          .doc('global')
          .collection('banned_messages')
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {'uid': messageId},
        );
      });
      print(documentReference.toString());
    }

    banMessages.add(messageId);
    setState(() {});
  }
}

List<String> bannedMessages() {
  List<String> users = [];

  FirebaseFirestore.instance
      .collection('streams')
      .doc(streamID)
      .collection('blacklist')
      .doc('local')
      .collection('users')
      .doc(SessionKeeper.user.uid)
      .collection('messages')
      .get()
      .then((snapshot) {
    print("messages len: " + snapshot.docs.length.toString());
    snapshot.docs.forEach((result) {
      users.add(result.get('uid'));
    });
  });

  FirebaseFirestore.instance
      .collection('streams')
      .doc(streamID)
      .collection('blacklist')
      .doc('global')
      .collection('banned_messages')
      .get()
      .then((snapshot) {
    snapshot.docs.forEach((result) {
      users.add(result.get('uid'));
    });
  });

  print("Messages: " + users.toString());
  return users;
}

List<String> bannedUsers() {
  List<String> users = [];

  FirebaseFirestore.instance
      .collection('streams')
      .doc(streamID)
      .collection('blacklist')
      .doc('local')
      .collection('users')
      .doc(SessionKeeper.user.uid)
      .collection('banned_users')
      .get()
      .then((snapshot) {
    print("users len: " + snapshot.docs.length.toString());
    snapshot.docs.forEach((result) {
      users.add(result.get('uid'));
    });
  });

  FirebaseFirestore.instance
      .collection('streams')
      .doc(streamID)
      .collection('blacklist')
      .doc('global')
      .collection('banned_users')
      .get()
      .then((snapshot) {
    snapshot.docs.forEach((result) {
      users.add(result.get('uid'));
    });
  });

  print("Users: " + users.toString());
  return users;
}
