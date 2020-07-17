import 'dart:io';
import 'package:enma/advance/Sizeconfig.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:enma/Profile/Profile.dart';

class EditProfileA extends StatefulWidget {
  EditProfileA({this.name, this.Email, this.contact, this.index, this.UImage});

  final String name;
  final String Email;
  final String contact;
  final String UImage;
  final index;


  @override
  _EditProfileAState createState() => new _EditProfileAState();
}

class _EditProfileAState extends State <EditProfileA> {

  //TextEditingController controllerBranch;
  TextEditingController controllerName;
  TextEditingController controllerId;
  TextEditingController controllerEmail;
  TextEditingController controllerContact;

  // ignore: non_constant_identifier_names
  String UName;
  // ignore: non_constant_identifier_names
  // ignore: non_constant_identifier_names
  File image;
  String filename;
  String UEmail;
  String UContact;
  String CImage;
  String url;
  List<String> _UserGender = <String>[
    'Male',
    'Female',
  ];

  Future _getImage() async {
    var selectedImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState((){
      image = selectedImage;
      filename = basename(image.path);
    });
    _uploadImage();
    print("$image");
  }

  _uploadImage() async {
    Firestore.instance.runTransaction((Transaction transaction) async {
      StorageReference ref = FirebaseStorage.instance.ref().child(filename);
      StorageUploadTask uploadTask = ref.putFile(image);
      var ImageURL = await (await uploadTask.onComplete).ref.getDownloadURL();
      CImage = ImageURL.toString();
      //DocumentSnapshot snapshot = await transaction.get(widget.index);
      //_updateEvent(CImage);
      print("$CImage");
      return CImage;
    });
  }

  uploadArea(){
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height:  300.0,
          margin: EdgeInsets.only(top: 30, bottom: 20),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(width: 3, color: Colors.blueGrey),
          ),
          child: Image.file(image, fit: BoxFit.contain,),
        ),
        //Image.file(image, width: double.infinity, height: 200.0)
      ],
    );
  }

  void _updateUser(String imageUrl){
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(widget.index);

      await transaction.update(snapshot.reference, {
        "name" : UName,
        "email" : UEmail,
        "Contact Number" : UContact,
        "User Image": imageUrl,
      });
    });
  }

  @override
  void initState() {
    super.initState();
    //_eventDate = widget.date;
    //_dateText = "${_eventDate.day}/${_eventDate.month}/${_eventDate.year}";
    UName = widget.name;
    UEmail = widget.Email;
    UContact = widget.contact;
    CImage = widget.UImage;
    //controllerBranch = new TextEditingController(text: widget.UBranch);
    controllerName = new TextEditingController(text: widget.name);
    controllerEmail = new TextEditingController(text: widget.Email);
    controllerContact = new TextEditingController(text: widget.contact);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Scaffold (
      resizeToAvoidBottomPadding: true,
      body: Stack(
        children: <Widget>[
          //HomeBg(screenHeight: MediaQuery.of(context).size.height,),
          SafeArea(
            child: Container(
              height: SizeConfig.screenHeight*1.0,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: SizeConfig.screenHeight*0.1,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.only(
                            bottomRight: const Radius.circular(50.0),
                          )
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                                  child: Row(
                                    children: <Widget>[
                                      IconButton(
                                          icon: Icon(Icons.arrow_back, color: Colors.white,),
                                          iconSize: 30.0,
                                          onPressed: (){
                                            Navigator.pop(context);
                                          }
                                      ),
                                      Text("Edit Profile",
                                        style: new TextStyle(fontSize: 24.0, color: Colors.white),)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: SizeConfig.screenHeight*0.9,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: image == null ?
                              Container(
                                height:300,
                                width:300,
                                margin: EdgeInsets.only(top: 30, bottom: 20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 3, color: Colors.blueGrey),
                                  image: DecorationImage(
                                      image: NetworkImage(CImage),
                                      fit: BoxFit.cover),
                                ),
                              ) : uploadArea(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: IconButton(
                                icon: Icon(FontAwesomeIcons.camera, size: 30.0),
                                onPressed: _getImage,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                controller: controllerName,
                                onChanged: (String str){
                                  setState(() {
                                    UName = str;
                                  });
                                },
                                decoration: new InputDecoration(
                                    icon: Icon(Icons.person),
                                    hintText: "Name",
                                    border: InputBorder.none
                                ),
                                style: new TextStyle(fontSize: 22.0, color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                controller: controllerEmail,
                                onChanged: (String str){
                                  setState(() {
                                    UEmail = str;
                                  });
                                },
                                decoration: new InputDecoration(
                                    icon: Icon(Icons.mail),
                                    hintText: "User Email",
                                    border: InputBorder.none
                                ),
                                style: new TextStyle(fontSize: 22.0, color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                controller: controllerContact,
                                onChanged: (String str){
                                  setState(() {
                                    UContact = str;
                                  });
                                },
                                decoration: new InputDecoration(
                                    icon: Icon(FontAwesomeIcons.phone),
                                    hintText: "Contact Number",
                                    border: InputBorder.none
                                ),
                                style: new TextStyle(fontSize: 22.0, color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 100.0, bottom: 100.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.check, size: 40, color: Colors.blue,),
                                    onPressed: (){
                                      //_uploadImage();
                                      _updateUser(CImage);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close, size: 40, color: Colors.redAccent,),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

