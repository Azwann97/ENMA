import 'dart:io';
import 'package:enma/advance/viewonmap.dart';
import 'package:enma/advance/Sizeconfig.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';



class EditEvent extends StatefulWidget {
  EditEvent({this.title, this.venue, this.date, this.time, this.index, this.UBranch, this.Stat, this.Image, this.Partake, this.docID, this.toe});

  final String docID;
  final String Partake;
  final String title;
  final String venue;
  final String time;
  final String toe;
  final DateTime date;
  final index;
  final String UBranch;
  final String Stat;
  final String Image;

  @override
  _EditEventState createState() => new _EditEventState();
}

class _EditEventState extends State <EditEvent> {

  //TextEditingController controllerBranch;
  TextEditingController controllerTitle;
  TextEditingController controllerVenue;
  TextEditingController controllerTime;
  TextEditingController controllerPartake;

  DateTime _eventDate;
  String _dateText;
  // ignore: non_constant_identifier_names
  String EName;
  // ignore: non_constant_identifier_names
  String ETime;
  // ignore: non_constant_identifier_names
  String EVenue;
  String EBranch;
  String CImage;
  File image;
  String filename;
  String Status;
  String TOE;
  String EPartake;
  String url;

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

  Future _getImage() async {
    var selectedImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState((){
      image = selectedImage;
      filename = basename(image.path);
    });
    _uploadImage();
    print("$image");
  }

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

  void _updateEvent(String imageUrl) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      /*
        StorageReference ref = FirebaseStorage.instance.ref().child(filename);
        StorageUploadTask uploadTask = ref.putFile(image);
        var ImageURL = await (await uploadTask.onComplete).ref.getDownloadURL();
        CImage = ImageURL.toString();
         */
      //updateImage(url);
      _uploadImage();
      print("$EName, $_eventDate,$EVenue,$EBranch,$ETime,$Status,$imageUrl,");
      DocumentSnapshot snapshot = await transaction.get(widget.index);

      await transaction.update(snapshot.reference, {
        "Event Name" : EName,
        "Date": _eventDate,
        "Time Start" : ETime,
        "Venue" : EVenue,
        "UiTM Branch" : EBranch,
        "Event Status" : Status,
        "Number of Participant Allowed" : EPartake,
        "Image": imageUrl,

      });
    });
  }

  @override
  void initState() {
    super.initState();
    _eventDate = widget.date;
    _dateText = "${_eventDate.day}/${_eventDate.month}/${_eventDate.year}";
    EBranch = widget.UBranch;
    CImage = widget.Image;
    EName = widget.title;
    ETime = widget.time;
    EPartake = widget.Partake;
    EVenue = widget.venue;
    Status = widget.Stat;
    TOE = widget.toe;
    //controllerBranch = new TextEditingController(text: widget.UBranch);
    controllerPartake = new TextEditingController(text: widget.Partake);
    controllerTitle = new TextEditingController(text: widget.title);
    controllerVenue = new TextEditingController(text: widget.venue);
    controllerTime = new TextEditingController(text: widget.time);
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
                                      Text("Edit Event",
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
                                margin: EdgeInsets.only(top: 30, bottom: 20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
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
                                controller: controllerTitle,
                                onChanged: (String str){
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
                                  new Expanded(child: Text("Event Date", style: new TextStyle(fontSize: 22.0, color: Colors.black),)),
                                  new FlatButton(
                                      onPressed: ()=> _selectEDate(context),
                                      child: Text( _dateText, style: new TextStyle(fontSize: 22.0, color: Colors.black),))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                controller: controllerTime,
                                onChanged: (String str){
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
                                controller: controllerPartake,
                                onChanged: (String str){
                                  setState(() {
                                    EPartake = str;
                                  });
                                },
                                decoration: new InputDecoration(
                                    icon: Icon(FontAwesomeIcons.personBooth),
                                    hintText: "Num. of Participant Allowed",
                                    border: InputBorder.none
                                ),
                                style: new TextStyle(fontSize: 22.0, color: Colors.black),
                              ),
                            ),
                            /*Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: controllerVenue,
                    onChanged: (String str){
                      setState(() {
                        EVenue = str;
                      });
                    },
                    decoration: new InputDecoration(
                        icon: Icon(Icons.map),
                        hintText: "Venue",
                        border: InputBorder.none
                    ),
                    style: new TextStyle(fontSize: 22.0, color: Colors.black),
                  ),
                ),*/
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
                                          SizedBox(width: 50.0),
                                          DropdownButton(
                                            value: EBranch,
                                            items: BranchList,
                                            onChanged: (Branch){
                                              setState(() {
                                                EBranch = Branch.toString();
                                              });
                                            },
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
                                          SizedBox(width: 50.0),
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
                                    Icon(FontAwesomeIcons.bookmark, size: 30.0, color: Colors.teal),
                                    SizedBox(width: 50.0),
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
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(FontAwesomeIcons.bookmark, size: 30.0, color: Colors.teal),
                                    SizedBox(width: 50.0),
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
                                          TOE = SelectedType;
                                        });
                                      },
                                      value: TOE,
                                      isExpanded: false,
                                      hint: Text("Select Event Type", style: TextStyle(color: Colors.black)),
                                    )]
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Container(
                                height: 100,
                                width: 300,
                                child: RaisedButton.icon(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  color: Colors.purple,
                                  onPressed: (){
                                    Navigator.push(context,MaterialPageRoute(builder: (context) => LocationMap( docId: widget.docID, eventName: widget.title )));
                                  },
                                  icon: Icon(Icons.location_on, color: Colors.blue,),
                                  label: Text("view event on the map", style: TextStyle(color: Colors.white, fontSize: 20),),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0, bottom: 100.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.check, size: 40, color: Colors.blue,),
                                    onPressed: (){
                                      //_uploadImage();
                                      _updateEvent(CImage);
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

