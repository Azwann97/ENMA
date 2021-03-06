import 'package:enma/advance/Sizeconfig.dart';
import 'package:enma/advance/loading1.dart';
import 'package:enma/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'EditEvent.dart';
import 'package:enma/advance/HomeBg.dart';
import 'AddEvent.dart';
import 'OrgHome.dart';


class DashboardO extends StatefulWidget {
  final String uid;
  final String contact;
  DashboardO({this.uid, this.contact});
  @override
  State<StatefulWidget> createState() => new _DashboardOState();
}

class _DashboardOState extends State<DashboardO>{
  final AuthService _auth = AuthService();
  FirebaseUser user;

  Stream<QuerySnapshot> events;

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('New Event Added', style: TextStyle(fontSize: 15.0)),
            content: Text('Added'),
            actions: <Widget>[
              FlatButton(
                child: Text('Alright'),
                textColor: Colors.teal,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          HomeBg(screenHeight: MediaQuery.of(context).size.height),
            SafeArea(
              child: Container(
                height: SizeConfig.screenHeight*1.0,
                width: SizeConfig.screenWidth*1.0,
                child: SingleChildScrollView(
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
                                  )
                                  //Text("Events", style: TextStyle(color: Colors.white, fontSize: 20.0),),
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
                              child: Text("My Event", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30.0),),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32.0),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Container(
                                  height: 50,
                                  child: RaisedButton.icon(
                                    color: Colors.orangeAccent,
                                    onPressed: (){
                                      Navigator.of(context).push(new MaterialPageRoute(
                                          builder: (BuildContext context) => new AddEvent(uid: widget.uid, contact: widget.contact)
                                      ));
                                      print('$image');
                                    },
                                    icon: Icon(Icons.add, color: Colors.white,),
                                    label: Text("Add New Event", style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                              StreamBuilder(
                                stream: Firestore.instance.collection("Registered Event").where("User Id", isEqualTo: widget.uid).orderBy("Date", descending: true).snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                  if(!snapshot.hasData){
                                    return new Container(
                                      child: Center(
                                        child: Loading1(),
                                      ),
                                    );
                                  }
                                  return Container(
                                      height: 500.0,
                                      child: new EventList(document: snapshot.data.documents, uid: widget.uid)
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      )
    );
  }
}


class EventList extends StatelessWidget {
  EventList({this.document, this.uid});
  final String uid;
  final List<DocumentSnapshot> document;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i){
        String title = document[i].data['Event Name'].toString();
        String venue = document[i].data['Venue'].toString();
        DateTime _date = document[i].data['Date'].toDate();
        String date = "${_date.day}/${_date.month}/${_date.year}";
        String time = document[i].data['Time Start'].toString();
        String Image = document[i].data['Image'].toString();
        String UiTMBranch = document[i].data['UiTM'].toString();
        String Status = document[i].data['Event Status'].toString();
        String Participant = document[i].data['Number of Participant Allowed'].toString();
        String image = document[i].data['Image'].toString();
        String TOE = document[i].data['Event Type'].toString();
        String contact = document[i].data['Contact Number'].toString();
        String docID = document[i].data['docID'];

        return Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Expanded(
                  child: InkWell(
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (context){
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: Container(
                                height: SizeConfig.screenHeight*0.84,
                                width: SizeConfig.screenWidth*1.0,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: SizeConfig.screenHeight*0.3,
                                        decoration: BoxDecoration(
                                            borderRadius: new BorderRadius.only(
                                                topLeft:  const  Radius.circular(10.0),
                                                topRight: const  Radius.circular(10.0)),
                                            image: DecorationImage(
                                                image: NetworkImage(Image),
                                                fit: BoxFit.cover,
                                                alignment: Alignment.center
                                            )
                                        ),
                                      ),
                                      Container(
                                        height: SizeConfig.screenHeight*0.4,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                                                  child: Text(title, style: new TextStyle(fontSize: 40.0, letterSpacing: 1.0, fontFamily:'Oswald'), textAlign: TextAlign.center,),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 10.0),
                                                  child: new Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 16.0),
                                                        child: Icon(Icons.star, color: Colors.blueAccent,),
                                                      ),
                                                      Text(TOE, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),)
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 10.0),
                                                  child: new Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 16.0),
                                                        child: Icon(Icons.date_range, color: Colors.blueAccent,),
                                                      ),
                                                      Text(date, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),)
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 10.0),
                                                  child: new Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 16.0),
                                                        child: Icon(FontAwesomeIcons.clock, color: Colors.blueAccent,),
                                                      ),
                                                      Text(time, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),)
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 10.0),
                                                  child: new Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 16.0),
                                                        child: Icon(FontAwesomeIcons.locationArrow, color: Colors.blueAccent,),
                                                      ),
                                                      new Expanded(child: Text(venue+","+UiTMBranch, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),))
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 10.0),
                                                  child: new Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 16.0),
                                                        child: Icon(FontAwesomeIcons.phone, color: Colors.blueAccent,),
                                                      ),
                                                      Text(contact, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),)
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          height: SizeConfig.screenHeight*0.07,
                                          width: double.infinity,
                                          child: RaisedButton.icon(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.zero,
                                              ),
                                              color: Colors.blueAccent,
                                              onPressed: (){
                                                Navigator.pop(context);
                                                Navigator.of(context).push(new MaterialPageRoute(
                                                    builder: (BuildContext context) => new EditEvent(
                                                      title: title,
                                                      venue: venue,
                                                      date: _date,
                                                      time: time,
                                                      Image : Image,
                                                      UBranch : UiTMBranch,
                                                      Stat : Status,
                                                      Partake : Participant,
                                                      index: document[i].reference,
                                                      docID:docID,
                                                      toe: TOE
                                                    )
                                                ));
                                              },
                                              icon: Icon(FontAwesomeIcons.edit, color: Colors.white,),
                                              label: Text("Edit", style: TextStyle(color: Colors.white))
                                          ),
                                        ),
                                      ),
                                      //Spacer(),
                                      Container(
                                        height: SizeConfig.screenHeight*0.07,
                                        width: double.infinity,
                                        child: RaisedButton.icon(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                bottomRight: const Radius.circular(10.0),
                                                bottomLeft: const  Radius.circular(10.0),
                                              ),
                                            ),
                                            color: Colors.redAccent,
                                            onPressed: (){
                                              Navigator.pop(context);
                                              showDialog(
                                                  context: context,
                                                  builder: (context){
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(20.0)
                                                      ),
                                                      child: Container(
                                                        height: SizeConfig.screenHeight*0.2,
                                                        width: double.infinity,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            Container(
                                                              height: SizeConfig.screenHeight*0.1,
                                                              width: double.infinity,
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Text("Are you sure want to delete this event?", style: TextStyle(fontSize: 20.0),),
                                                              ),
                                                            ),
                                                            Container(
                                                              height: SizeConfig.screenHeight*0.05,
                                                              width: double.infinity,
                                                              child: RaisedButton.icon(
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.zero,
                                                                  ),
                                                                  color: Colors.blueAccent,
                                                                  onPressed: (){

                                                                    Firestore.instance.runTransaction((Transaction transaction) async {
                                                                      DocumentSnapshot snapshot = await transaction.get(document[i].reference);
                                                                      await transaction.delete(snapshot.reference);
                                                                      Navigator.pop(context);
                                                                    });
                                                                  },
                                                                  icon: Icon(FontAwesomeIcons.check, color: Colors.white,),
                                                                  label: Text("yes", style: TextStyle(color: Colors.white))
                                                              ),
                                                            ),
                                                            Container(
                                                              height: SizeConfig.screenHeight*0.05,
                                                              width: double.infinity,
                                                              child: RaisedButton.icon(
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.only(
                                                                      bottomRight: const Radius.circular(10.0),
                                                                      bottomLeft: const  Radius.circular(10.0),
                                                                    ),
                                                                  ),
                                                                  color: Colors.redAccent,
                                                                  onPressed: (){
                                                                    Navigator.pop(context);
                                                                  },
                                                                  icon: Icon(FontAwesomeIcons.times, color: Colors.white,),
                                                                  label: Text("No", style: TextStyle(color: Colors.white))
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }
                                              );
                                            },
                                            icon: Icon(FontAwesomeIcons.trash, color: Colors.white,),
                                            label: Text("Remove", style: TextStyle(color: Colors.white))
                                        ),
                                      ),
                                    ],
                                  ),
                              ),
                            );
                          }
                      );
                      print("clicked");
                    },
                    child: Container(
                      width: 250,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 300,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                    topLeft:  const  Radius.circular(10.0),
                                    bottomLeft: const  Radius.circular(10.0)),
                                image: DecorationImage(
                                  image: NetworkImage(image),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Text(title, style: new TextStyle(fontSize: 30.0, letterSpacing: 1.0,),),
                                    ),
                                    new Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(right: 16.0, bottom: 10.0),
                                          child: Icon(Icons.map, color: Colors.blueAccent,),
                                        ),
                                        new Expanded(child: Text(venue+", "+UiTMBranch, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),)),
                                      ],
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(right: 16.0, bottom: 10.0),
                                          child: Icon(Icons.date_range, color: Colors.blueAccent,),
                                        ),
                                        Text(date, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),)
                                      ],
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(right: 16.0, bottom: 10.0),
                                          child: Icon(FontAwesomeIcons.clock, color: Colors.blueAccent,),
                                        ),
                                        Text(time, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),)
                                      ],
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(right: 16.0, bottom: 10.0),
                                          child: Icon(FontAwesomeIcons.star, color: Colors.blueAccent,),
                                        ),
                                        Expanded(child: Text(TOE, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),))
                                      ],
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
            )
          );
      },
    );
  }
}
