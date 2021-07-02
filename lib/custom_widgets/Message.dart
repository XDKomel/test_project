
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plane_chat/models/SessionKeeper.dart';
import 'package:plane_chat/screens/home/profile.dart';

class Message extends StatefulWidget {
  final int index;
  final DocumentSnapshot document;
  Message({required this.index, required this.document});
  @override
  _MessageState createState() => _MessageState(document: document, index: index);
}

class _MessageState extends State<Message> {
  final int index;
  final DocumentSnapshot document;
  _MessageState({required this.index, required this.document});
  @override
  Widget build(BuildContext context) {
    String uid = document.get('user_id') ?? "";
    String avatarUrl='';
    FirebaseStorage.instance
        .ref()
        .child('users')
        .child(uid)
        .child('avatar')
        .getDownloadURL()
        .then((value)  {
      setState(() {
        avatarUrl = value;
      });
    });
    String name = document.get('username') ?? "";
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
              child: avatarUrl.length>0? CircleAvatar(
                radius: 17.5,
                child: Image.network(avatarUrl,  height: 35,
                  width: 35,
                  fit: BoxFit.cover,),
              ) : Container(
                margin: EdgeInsets.only(right: 5),
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF5283B7), Color(0xFFB45590)],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  image:  DecorationImage(
                      scale: 0.4,
                      image: ExactAssetImage('assets/images/person-icon-white.png'),
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
                            child: SelectableText(
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
                gradient: (uid == SessionKeeper.user.uid)? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF5283B7), Color(0xFFB45590)],
                ) : null,
                color: (uid != SessionKeeper.user.uid)
                    ? Color(0xffF4F4F6)
                    : null,
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
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF5283B7), Color(0xFFB45590)],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  image: DecorationImage(
                      scale: 0.4,
                      image: ExactAssetImage('assets/images/person-icon-white.png'),
                      //[ExactAssetImage('android/assets/images/woman.png'),ExactAssetImage('android/assets/images/man.png'),ExactAssetImage('android/assets/images/woman2.png')][_random.nextInt(3)],
                      fit: BoxFit.contain),
                ),
              ),
            ),
        ]);
  }

  Future<void> banUser({String? userId, String? streamId}) async {
    if (!SessionKeeper.user.authorities.contains(Authority.ADMIN)) {
      var documentReference = FirebaseFirestore.instance
          .collection('streams')
          .doc(streamId).collection('flights').doc(time.seconds.toString())
          .collection('blacklist')
          .doc('local')
          .collection('users')
          .doc(SessionKeeper.user.uid)
          .collection('banned_users')
          .doc(DateTime
          .now()
          .millisecondsSinceEpoch
          .toString());

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
          .doc(streamId).collection('flights').doc(time.seconds.toString())
          .collection('blacklist')
          .doc('global')
          .collection('banned_users')
          .doc(DateTime
          .now()
          .millisecondsSinceEpoch
          .toString());

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
          .doc(streamId).collection('flights').doc(time.seconds.toString())
          .collection('blacklist')
          .doc('local')
          .collection('users')
          .doc(SessionKeeper.user.uid)
          .collection('messages')
          .doc(DateTime
          .now()
          .millisecondsSinceEpoch
          .toString());

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
          .doc(streamId).collection('flights').doc(time.seconds.toString())
          .collection('blacklist')
          .doc('global')
          .collection('banned_messages')
          .doc(DateTime
          .now()
          .millisecondsSinceEpoch
          .toString());

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


  List<String> bannedMessages() {
    List<String> users = [];

    FirebaseFirestore.instance
        .collection('streams')
        .doc(streamID).collection('flights').doc(time.seconds.toString())
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
        .doc(streamID).collection('flights').doc(time.seconds.toString())
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
        .doc(streamID).collection('flights').doc(time.seconds.toString())
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
        .doc(streamID).collection('flights').doc(time.seconds.toString())
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

}