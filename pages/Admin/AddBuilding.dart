import 'dart:io';
import 'package:enma/advance/Sizeconfig.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';


class AddBuilding extends StatefulWidget {
  AddBuilding({this.uid, this.contact});
  final String uid;
  final String contact;

  @override
  _AddBuildingState createState() => new _AddBuildingState();
}

class _AddBuildingState extends State <AddBuilding> {

  // ignore: non_constant_identifier_names
  String bName = "";
  String EBranch;
  // ignore: non_constant_identifier_names

  void _addNewBuilding() {
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('Venue');
      await reference.add({
        "BName" : EBranch,
        "VName" : bName,
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
                                      Text("Add New Building / Room", style: new TextStyle(fontSize: 24.0, color: Colors.white),)
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
                              StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance.collection('UiTMBranch').snapshots(),
                                  // ignore: missing_return
                                  builder: (context, snapshot) {
                                    if(!snapshot.hasData) {
                                      Text('Loading..');
                                    }
                                    else {
                                      // ignore: non_constant_identifier_names
                                      List<DropdownMenuItem> BranchList = [];
                                      for (int i=0; i<snapshot.data.documents.length; i++){
                                        DocumentSnapshot snapshots = snapshot.data.documents[i];
                                        BranchList.add(
                                            DropdownMenuItem(
                                              child: Text(
                                                snapshots.data['BranchName'],
                                                style: TextStyle(color: Colors.black),
                                              ),
                                              value: "${snapshots.data['BranchName']}",
                                            )
                                        );
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(FontAwesomeIcons.building, size: 30.0, color: Colors.teal,),
                                            SizedBox(width: SizeConfig.screenWidth*0.1),
                                            DropdownButton(
                                              items: BranchList,
                                              onChanged: (Branch){
                                                setState(() {
                                                  EBranch = Branch.toString();
                                                });
                                              },
                                              value: EBranch,
                                              isExpanded: false,
                                              hint: new Text("Choose UiTM Branch                                 "),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  }
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextField(
                                  onChanged: (String str) {
                                    setState(() {
                                      bName = str;
                                    });
                                  },
                                  decoration: new InputDecoration(
                                      icon: Icon(Icons.dashboard),
                                      hintText: "Room / Building Name",
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
                                        _addNewBuilding();
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


