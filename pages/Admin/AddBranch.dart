import 'dart:io';
import 'package:enma/advance/Sizeconfig.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';


class AddBranch extends StatefulWidget {
  AddBranch({this.uid, this.contact});
  final String uid;
  final String contact;

  @override
  _AddBranchState createState() => new _AddBranchState();
}

class _AddBranchState extends State <AddBranch> {

  // ignore: non_constant_identifier_names
  String BName = "";
  // ignore: non_constant_identifier_names

  void _addNewBranch() {
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('UiTMBranch');
      await reference.add({
        "BranchName" : BName,
      });
    });
    Navigator.pop(this.context);
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
                      height: SizeConfig.screenHeight*0.2,
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
                                      Text("Add New UiTM Branch",
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
                    Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Container(
                        height: SizeConfig.screenHeight*0.9,
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextField(
                                  onChanged: (String str) {
                                    setState(() {
                                      BName = str;
                                    });
                                  },
                                  decoration: new InputDecoration(
                                      icon: Icon(Icons.dashboard),
                                      hintText: "Branch Name",
                                      border: InputBorder.none
                                  ),
                                  style: new TextStyle(fontSize: 22.0, color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 50.0, bottom: 100.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.check, size: 40, color: Colors.blue,),
                                      onPressed: () {
                                        _addNewBranch();
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close, size: 40, color: Colors.redAccent,),
                                      onPressed: () {
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


