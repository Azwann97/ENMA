import 'dart:io';
import 'package:enma/advance/EventMarker.dart';
import 'package:enma/advance/HomeBg.dart';
import 'package:enma/advance/Sizeconfig.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'OrgHome.dart';

File image;
String filename;

class AddEvent extends StatefulWidget {
  AddEvent({this.uid, this.contact});
  final String uid;
  final String contact;

  @override
  _AddEventState createState() => new _AddEventState();
}

class _AddEventState extends State <AddEvent> {

  DateTime _eventDate = new DateTime.now();
  String _dateText = "";
  // ignore: non_constant_identifier_names
  String EName = "";
  // ignore: non_constant_identifier_names
  String ETime = "";
  // ignore: non_constant_identifier_names
  String EVenue;
  // ignore: non_constant_identifier_names
  String EBranch;
  String Status;
  String EType;
  int EPNum;
  List<String> _EventStat = <String>[
    'Activate',
    'Deactivate',
  ];
  List<String> _EventType = <String>[
    'Extreme Sports',
    'Sports & Recreation',
    'Technology & Information',
    'Multimedia',
    'Landscape',
    'Plantation',
    'Community Charity',
    'Social Activity',
  ];

  Future<Null> _selectEDate(BuildContext context) async{
    final picked = await  showDatePicker(
        context: context,
        initialDate: _eventDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030)
    );

    if(picked != null) {
      setState(() {
        _eventDate = picked;
        _dateText = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
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
          child: Image.file(image, fit: BoxFit.cover,),
        ),
        //Image.file(image, width: double.infinity, height: 200.0)
      ],
    );
  }

  void _addNewEvent({String contact}) {


    Firestore.instance.runTransaction((Transaction transaction) async {
      StorageReference ref = FirebaseStorage.instance.ref().child(filename);
      StorageUploadTask uploadTask = ref.putFile(image);
      var ImageURL = await (await uploadTask.onComplete).ref.getDownloadURL();
      var url = ImageURL.toString();

      CollectionReference reference = Firestore.instance.collection('Registered Event');
      await reference.add({
        "User Id" : widget.uid,
        "Event Name" : EName,
        "Date": _eventDate,
        "Time Start" : ETime,
        "Venue" : EVenue,
        "Image" : url,
        "Event Status" : Status,
        "UiTM" : EBranch,
        "Number of Participant Allowed" : EPNum,
        "Event Type" : EType,
        "Availability" : EPNum,
        "Contact Number" : widget.contact,
      });
    });


    Navigator.pop(this.context);
  }

  Future _getImage() async {
    var selectedImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState((){
      image = selectedImage;
      filename = basename(image.path);
    });
  }

  @override
  void initState() {
    super.initState();
    _dateText = "${_eventDate.day}/${_eventDate.month}/${_eventDate.year}";
    setState(() {
      image = null;
    });
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
                                                  Text("Create New Event",
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
                                            width: double.infinity,
                                            height:  300.0,
                                            margin: EdgeInsets.only(top: 20, bottom: 10),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              border: Border.all(width: 1, color: Colors.blueGrey),
                                            ),
                                            child: Center(child: Text("Upload your event image here", style: TextStyle(fontSize: 20.0),)),
                                          ): uploadArea(),
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
                                            onChanged: (String str) {
                                              setState(() {
                                                EName = str;
                                              });
                                            },
                                            decoration: new InputDecoration(
                                                icon: Icon(Icons.dashboard),
                                                hintText: "Event Name",
                                                border: InputBorder.none
                                            ),
                                            style: new TextStyle(fontSize: 22.0, color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: new Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(right: 16.0),
                                                child: new Icon(Icons.date_range),
                                              ),
                                              new Expanded(child: Text("Event Date",
                                                style: new TextStyle(fontSize: 22.0, color: Colors.black),)),
                                              new FlatButton(
                                                  onPressed: () => _selectEDate(context),
                                                  child: Text(_dateText, style: new TextStyle(
                                                      fontSize: 22.0, color: Colors.black),))
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: TextField(
                                            keyboardType: TextInputType.datetime,
                                            onChanged: (String str) {
                                              setState(() {
                                                ETime = str;
                                              });
                                            },
                                            decoration: new InputDecoration(
                                                icon: Icon(Icons.watch),
                                                hintText: "Time",
                                                border: InputBorder.none
                                            ),
                                            style: new TextStyle(fontSize: 22.0, color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            onChanged: (String num) {
                                              setState(() {
                                                EPNum = int.parse(num);
                                              });
                                            },
                                            decoration: new InputDecoration(
                                                icon: Icon(FontAwesomeIcons.personBooth),
                                                hintText: "Num of. Participant Allowed",
                                                border: InputBorder.none
                                            ),
                                            style: new TextStyle(fontSize: 22.0, color: Colors.black),
                                          ),
                                        ),
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
                                                      SizedBox(width: SizeConfig.screenWidth*0.2),
                                                      DropdownButton(
                                                        items: BranchList,
                                                        onChanged: (Branch){
                                                          setState(() {
                                                            EBranch = Branch.toString();
                                                          });
                                                        },
                                                        value: EBranch,
                                                        isExpanded: false,
                                                        hint: new Text("Choose UiTM Branch"),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }
                                            }
                                        ),
                                        StreamBuilder<QuerySnapshot>(
                                            stream: Firestore.instance.collection('Venue').where("BName", isEqualTo: EBranch).snapshots(),
                                            // ignore: missing_return
                                            builder: (context, snapshot) {
                                              if(!snapshot.hasData) {
                                                Text('Loading..');
                                              }
                                              else {
                                                // ignore: non_constant_identifier_names
                                                List<DropdownMenuItem> VenueList = [];
                                                for (int i=0; i<snapshot.data.documents.length; i++){
                                                  DocumentSnapshot snapshots = snapshot.data.documents[i];
                                                  VenueList.add(
                                                      DropdownMenuItem(
                                                        child: Text(
                                                          snapshots.data['VName'],
                                                          style: TextStyle(color: Colors.black),
                                                        ),
                                                        value: "${snapshots.data['VName']}",
                                                      )
                                                  );
                                                }
                                                return Padding(
                                                  padding: const EdgeInsets.all(16.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Icon(FontAwesomeIcons.marker, size: 30.0, color: Colors.teal,),
                                                      SizedBox(width: SizeConfig.screenWidth*0.2),
                                                      DropdownButton(
                                                        items: VenueList,
                                                        onChanged: (Venue){
                                                          setState(() {
                                                            EVenue = Venue.toString();
                                                          });
                                                        },
                                                        value: EVenue,
                                                        isExpanded: false,
                                                        hint: new Text("Choose Location"),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }
                                            }
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(FontAwesomeIcons.star, size: 30.0, color: Colors.teal),
                                                SizedBox(width: SizeConfig.screenWidth*0.2),
                                                DropdownButton(
                                                  items: _EventType.map((value)=>DropdownMenuItem(
                                                    child: Text(
                                                      value,
                                                      style: TextStyle(color: Colors.black),
                                                    ),
                                                    value : value,
                                                  )).toList(),
                                                  onChanged: (SelectedType){
                                                    setState(() {
                                                      EType = SelectedType;
                                                    });
                                                  },
                                                  value: EType,
                                                  isExpanded: false,
                                                  hint: Text("Select Event Type", style: TextStyle(color: Colors.black)),
                                                )]
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(FontAwesomeIcons.bookmark, size: 30.0, color: Colors.teal),
                                                SizedBox(width: SizeConfig.screenWidth*0.2),
                                                DropdownButton(
                                                  items: _EventStat.map((value)=>DropdownMenuItem(
                                                    child: Text(
                                                      value,
                                                      style: TextStyle(color: Colors.black),
                                                    ),
                                                    value : value,
                                                  )).toList(),
                                                  onChanged: (SelectedStatus){
                                                    setState(() {
                                                      Status = SelectedStatus;
                                                    });
                                                  },
                                                  value: Status,
                                                  isExpanded: false,
                                                  hint: Text("Select Event Status", style: TextStyle(color: Colors.black)),
                                                )]
                                          ),
                                        ),
                                          Padding(
                                              padding: const EdgeInsets.only(top: 20.0, bottom: 100.0),
                                              child: Container(
                                                height: 100,
                                                width: 300,
                                                child: RaisedButton.icon(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(18.0),
                                                  ),
                                                  color: Colors.purple,
                                                  onPressed: (){
                                                    Navigator.of(context).push(new MaterialPageRoute(
                                                        builder: (BuildContext context) => new FireMap(contact: widget.contact, uid: widget.uid, eventName: EName, eventDate: _eventDate, eventTime: ETime, image: filename, status: Status, uitm: EBranch, part: EPNum, type: EType, venue: EVenue)
                                                    ));
                                                  },
                                                  icon: Icon(Icons.location_on, color: Colors.blue,),
                                                  label: Text("Mark event on the map", style: TextStyle(color: Colors.white, fontSize: 20),),
                                                ),
                                              ),
                                            ),
                                        /*Padding(
                                          padding: const EdgeInsets.only(top: 50.0, bottom: 100.0),
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              IconButton(
                                                icon: Icon(Icons.check, size: 40, color: Colors.blue,),
                                                onPressed: () {
                                                  _addNewEvent(contact: widget.contact);
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
                                        )*/
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

/*body: Stack(
        children: <Widget>[
          HomeBg(screenHeight: MediaQuery.of(context).size.height),
          SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: SizeConfig.screenHeight*0.8,
                    width: SizeConfig.screenWidth*1.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: SizeConfig.screenHeight*0.1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: SizeConfig.screenHeight*0.2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                                child: Text("New Event", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30.0),),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
          )
        ],
      ),*/

