import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plane_chat/custom_widgets/gallery_widget.dart';
import 'package:plane_chat/custom_widgets/rounded_button.dart';
import 'package:plane_chat/custom_widgets/rounded_input_field.dart';
import 'package:plane_chat/models/SessionKeeper.dart';
import 'package:plane_chat/screens/authentication/authenticate.dart';
import 'package:plane_chat/services/auth.dart';
import 'package:plane_chat/shared/constants.dart' as constants;
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  String uid;

  Profile({required this.uid});

  @override
  _ProfileState createState() => _ProfileState(uid: uid);
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  final picker = ImagePicker();
  File _imageFile = File('');

  String name = '';
  String email = '';
  String contact = '';
  String description='';
  String uid;
  String avatarUrl='';

  bool isMine = false;
  bool isPicked = false;
  TextEditingController name_controller = TextEditingController();
  TextEditingController contact_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();


  _ProfileState({required this.uid});

  Future<String> getName() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(uid);
    String name = '';
    await documentReference.get().then((snapshot) {
      name = snapshot.get('name');
    });
    return name;
  }

  Future<String> getEmail() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(uid);
    String email = '';
    await documentReference.get().then((snapshot) {
      email = snapshot.get('email');
    });
    return email;
  }

  Future<String> getContact() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(uid);
    String contact = '';
    await documentReference.get().then((snapshot) {
      contact = snapshot.get('contact');
    });
    return contact;
  }
  Future<String> getDescription() async {
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection('users').doc(uid);
    String description = '';
    await documentReference.get().then((snapshot) {
      description = snapshot.get('description');
    });
    return description;
  }
  @override
  void initState() {
    super.initState();
    getName().then((value) async {
      if (value.isNotEmpty)
        setState(() {
          name = value;
          name_controller..text = name;
          contact_controller..text = contact;
          description_controller..text = description;
        });
    });
    getContact().then((value) async {
      if (value.isNotEmpty)
        setState(() {
          contact = value;
          name_controller..text = name;
          contact_controller..text = contact;
          description_controller..text = description;
        });
    });
    getDescription().then((value) async {
      if (value.isNotEmpty)
        setState(() {
          description = value;
          name_controller..text = name;
          contact_controller..text = contact;
          description_controller..text = description;
        });
    });

  }
  @override
  Widget build(BuildContext context) {
    isMine = uid == FirebaseAuth.instance.currentUser!.uid;
    Size size = MediaQuery.of(context).size;


    // final prefs = SharedPreferences.getInstance().then((value) {
    //   name = value.getString('name')!;
    // });

    FirebaseStorage.instance
        .ref()
        .child('users')
        .child(uid)
        .child('avatar')
        .getDownloadURL()
        .then((value) => {
          avatarUrl = value
      });
    return Scaffold(
      extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(constants.APPBAR_SIZE),
          child: AppBar(
            title: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                "Назад",
                style: TextStyle(color: Color(0xFF5283B7), fontSize: 16),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leadingWidth: 20,
            leading: Container(
              margin: EdgeInsets.only(left: 8),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Color(0xFF5283B7),size: 20,),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            actions: <Widget>[
              Icon(
                Icons.logout,
                size: 20,
                color: Color(0xFF5283B7),
              ),
              Container(
                margin: EdgeInsets.only(left: 0),
                child: TextButton(
                    onPressed: () async {
                      await _auth.signOut();
                      Navigator.popUntil(context, (route) => false);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Authenticate()),
                      );
                    },
                    child: Text(
                      constants.LOG_OUT,
                      style: TextStyle(color: Color(0xFF5283B7), fontSize: 16),
                    )),
              )
            ],
          ),
        ),
        body: Container(
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
            padding: EdgeInsets.only(top: size.height * 0.01),
            child: SingleChildScrollView(
                child: SizedBox(
                    height: size.height,
                    child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        //mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          // Spacer(),
                          SizedBox(
                            height: 34 + constants.APPBAR_SIZE,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                            child: Stack(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 70,
                                  child: Container(
                                    child: ClipOval(
                                      child: avatarUrl.length>0? (isPicked? Image.file(_imageFile,height: 150,
                                        width: 150,
                                        fit: BoxFit.cover,) : Image.network(avatarUrl,  height: 150,
                                        width: 150,
                                        fit: BoxFit.cover,))
                                          : Image.asset(
                                        'assets/images/person-icon-white.png',
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFF5283B7),
                                          Color(0xFFB45590)
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                                if(isMine) Positioned(
                                    bottom: 1,
                                    right: 1,
                                    child: InkWell(
                                      onTap: (){
                                        setState(() {
                                          pickImage();
                                          // showGalleryModal(context,
                                          //     galleryType: GalleryType.SINGLE_CHOICE,
                                          //     galleryTitle: 'profile_photo'.tr(),
                                          //     cropType: CropType.CIRCLE)
                                          //     .then((image) {
                                          //   if (image != null) {
                                          //     _imageFile=image;
                                          //     uploadImageToFirebase(context);
                                          //   }
                                          // });
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        child: Icon(
                                          Icons.add_a_photo,
                                          color: Colors.white,
                                        ),

                                        decoration: BoxDecoration(
                                            color: Color(0xFFB45590),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                      ),
                                    ))
                              ],
                            ),
                          ),

                          Container(
                            margin:
                                EdgeInsets.only(left: 23, right: 23, bottom: 8),
                            child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                      colors: [
                                        Color.fromARGB(255, 255, 255, 255),
                                        Color.fromARGB(255, 224, 224, 224)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 2,
                                        blurRadius: 3,
                                        offset: Offset(0, 4), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 16, right: 16, top: 8, bottom: 8),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          textAlign: TextAlign.start,
                                          textInputAction: TextInputAction.next,

                                          controller: name_controller,
                                          //textAlign: TextAlign.center,
                                          keyboardType: TextInputType.text,
                                          // initialValue: name,
                                          onChanged: (name) {
                                            this.name = name;
                                            // name_controller.text=name;
                                          },
                                          readOnly: !isMine,

                                          style: TextStyle(color: Colors.black),

                                          decoration: InputDecoration(
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey,
                                              fontSize: 18,
                                            ),
                                            labelText: constants.NAME.tr(),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                        Divider(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          textAlign: TextAlign.start,
                                         readOnly: !isMine,
                                          textInputAction: TextInputAction.next,
                                          // initialValue: contact,
                                          controller: contact_controller,
                                          //textAlign: TextAlign.center,
                                          keyboardType: TextInputType.text,
                                          onChanged: (contact) {
                                            this.contact = contact;
                                            // contact_controller.text=contact;
                                          },

                                          style: TextStyle(color: Colors.black),

                                          decoration: InputDecoration(
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey,
                                              fontSize: 18,
                                            ),
                                            labelText: "Контакт",
                                            border: InputBorder.none,
                                          ),
                                        ),
                                        Divider(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          textAlign: TextAlign.start,
                                          readOnly: !isMine,
                                          textInputAction: TextInputAction.next,
                                          // initialValue: contact,
                                          controller: description_controller,
                                          //textAlign: TextAlign.center,
                                          keyboardType: TextInputType.text,
                                          onChanged: (description) {
                                            this.description = description;
                                            // contact_controller.text=contact;
                                          },

                                          style: TextStyle(color: Colors.black),

                                          decoration: InputDecoration(
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey,
                                              fontSize: 18,
                                            ),
                                            labelText: "О себе",
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ),

                          // Center(
                          //   child: Text(name,
                          //       style: TextStyle(
                          //         fontFamily: "Baloo",
                          //         color: Colors.black,
                          //         fontSize: 30,
                          //         fontWeight: FontWeight.bold,
                          //       )),
                          // ),
                          // Center(
                          //   child: RichText(
                          //     text: TextSpan(
                          //       text: contact,
                          //         recognizer: TapGestureRecognizer()
                          //           ..onTap = () {
                          //             Clipboard.setData(ClipboardData(text: contact));
                          //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //               content: Text("Скопировано в буфер обмена!"),
                          //             ));
                          //           },
                          //       style: TextStyle(
                          //         fontFamily: "Baloo",
                          //         color: Colors.black,
                          //         fontSize: 20,
                          //         fontWeight: FontWeight.normal,
                          //       )),
                          // ),
                          // ),


                          if(isMine) Spacer(),

                          if(isMine) Container(
                            margin: EdgeInsets.only(
                                left: 23, right: 23, bottom: 21),
                            child: RoundedButton(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Color(0xFF5283B7), Color(0xFFB45590)],
                              ),
                              text: "Сохранить",
                              textColor: Colors.white,
                              textSize: 20,
                              press: () async {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .update({
                                  'name': name_controller.text,
                                  'contact': contact_controller.text,
                                  'description': description_controller.text,
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Сохранено!"),
                                ));
                              },
                            ),
                          ),
                          if(isMine) Spacer(),

                          // Container(
                          //   margin: EdgeInsets.symmetric(horizontal: 23),
                          //   child: RoundedInputField(
                          //       initialValue: name,
                          //       //textAlign: TextAlign.center,
                          //       keyboard: TextInputType.text,
                          //       width: 0.85,
                          //       maxHeight: 0.07,
                          //       maxCharacters: 30,
                          //       onChanged: (name) {
                          //         this.name = name;
                          //       },
                          // ),
                          // ),
                        ])))));
  }


  void pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile!.path);
      uploadImageToFirebase(context);
      isPicked=true;
    });
  }

  void uploadImageToFirebase(BuildContext context) async {
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('users')
        .child(uid)
        .child('avatar');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    uploadTask.whenComplete(() async {
      avatarUrl= await firebaseStorageRef.getDownloadURL();
    });
  }

}
