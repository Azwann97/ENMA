import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enma/advance/HomeBg.dart';
import 'package:enma/advance/Sizeconfig.dart';
import 'package:enma/advance/viewonmap2.dart';
import 'package:enma/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:enma/pages/NormUser/Home.dart';

class All extends StatefulWidget{
  All({this.uid});
  final String uid;
  @override
  State<StatefulWidget> createState() => new _AllState();

}

class _AllState extends State<All>{
  String Stat = 'Activate';
  final AuthService _auth = AuthService();
  Stream<QuerySnapshot> events;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
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
                            child: Text("All Events", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30.0),),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          StreamBuilder(
                            stream: Firestore.instance.collection("Registered Event").where("Event Status", isEqualTo: 'Activate').where('Date', isGreaterThanOrEqualTo: DateTime.now()).orderBy("Date", descending: true).snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                              if(!snapshot.hasData){
                                return new Container(
                                  child: Center(
                                    //child: Loading1(),
                                    child: Center(child: Text("Sorry, there is no upcoming events for now")),
                                  ),
                                );
                              }
                              return Container(
                                  height: 500.0,
                                  child: new AllEventList(document: snapshot.data.documents, uid: widget.uid,)
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    /*Padding(

                        padding: const EdgeInsets.only(top: 100.0),
                        child: StreamBuilder(

                          stream: Firestore.instance.collection("Registered Event").where("Event Status", isEqualTo: 'Activate').snapshots(),
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
                                child: new AllEventList(document: snapshot.data.documents,)
                            );
                          },
                        ),
                    ),*/
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

// ignore: non_constant_identifier_names
void _Join(String references, String uid, String title, String time,  DateTime _date, String venue, String UiTMBranch, String Status, String Participant, String image, String toe, String contact) {
  Firestore.instance.runTransaction((Transaction transaction) async {
    CollectionReference reference = Firestore.instance.collection('Joined Event');
    await reference.add({
      "User Id" : uid,
      "Event Id" : references,
      "Event Name" : title,
      "Date": _date,
      "Time Start" : time,
      "Venue" : venue,
      "Image" : image,
      "Event Status" : Status,
      "UiTM" : UiTMBranch,
      "Number of Participant Allowed" : Participant,
      "Event Type": toe,
      "Contact Number": contact,
    });
  });
}

void _UpdateAvailability( {DocumentReference index, int Available}){

  Firestore.instance.runTransaction((Transaction transaction) async {
    DocumentSnapshot snapshot = await transaction.get(index);

    await transaction.update(snapshot.reference, {
      "Availability" : Available,
    });
  });
}

class AllEventList extends StatelessWidget {

  AllEventList({this.document, this.uid});
  final String uid;
  final List<DocumentSnapshot> document;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i){
        String title = document[i].data['Event Name'].toString();
        String venue = document[i].data['Venue'].toString();
        DateTime _date = document[i].data['Date'].toDate();
        String date = "${_date.day}/${_date.month}/${_date.year}";
        String time = document[i].data['Time Start'].toString();
        String image = document[i].data['Image'].toString();
        String UiTMBranch = document[i].data['UiTM'].toString();
        String Status = document[i].data['Event Status'].toString();
        String Participant = document[i].data['Number of Participant Allowed'].toString();
        String Available = document[i].data['Availability'].toString();
        int Availability = document[i].data['Availability'];
        String references = document[i].documentID;
        String contact = document[i].data['Contact Number'].toString();
        String TOE = document[i].data['Event Type'].toString();
        String docID = document[i].data['docID'];

        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                stream: Firestore.instance.collection("Joined Event").where("User Id", isEqualTo: uid).where("Event Name", isEqualTo: title).orderBy("Date", descending: true).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(!snapshot.hasData){
                    return new Padding(
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
                                            borderRadius: BorderRadius.circular(20.0)
                                        ),
                                        child: Container(
                                          height: SizeConfig.screenHeight*0.8,
                                          child: Column(
                                              children: <Widget>[
                                                Container(
                                                  height: SizeConfig.screenHeight*0.2,
                                                  decoration: BoxDecoration(
                                                      borderRadius: new BorderRadius.only(
                                                          topLeft:  const  Radius.circular(20.0),
                                                          topRight: const  Radius.circular(20.0)),
                                                      image: DecorationImage(
                                                          image: NetworkImage(image),
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
                                                                  child: Icon(FontAwesomeIcons.personBooth, color: Colors.blueAccent,),
                                                                ),
                                                                Text(Available+" / "+Participant, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),)
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
                                                SizedBox(
                                                  child: Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Container(
                                                      height: SizeConfig.screenHeight*0.1,
                                                      width: double.infinity,
                                                      child: RaisedButton.icon(
                                                          color: Colors.purple,
                                                          onPressed: (){
                                                            Navigator.push(context,MaterialPageRoute(builder: (context) => LocationMapNormal( docId: docID, eventName: title )));
                                                          },
                                                          icon: Icon(Icons.location_on, color: Colors.white,),
                                                          label: Text("View on Map", style: TextStyle(color: Colors.white))
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  child: Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Container(
                                                      height: SizeConfig.screenHeight*0.1,
                                                      width: double.infinity,
                                                      child: RaisedButton.icon(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.only(
                                                              bottomLeft: const  Radius.circular(10.0),
                                                              bottomRight: const Radius.circular(10.0),
                                                            ),
                                                          ),
                                                          color: Colors.blueAccent,
                                                          onPressed: (){
                                                            Availability = Availability - 1;
                                                            _Join(references, uid, title, time, _date, venue, UiTMBranch, Status, Participant, image, TOE, contact);
                                                            _UpdateAvailability(index: document[i].reference, Available: Availability);
                                                            Navigator.pop(context);
                                                          },
                                                          icon: Icon(FontAwesomeIcons.edit, color: Colors.white,),
                                                          label: Text("Join", style: TextStyle(color: Colors.white))
                                                      ),
                                                    ),
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
                      ),
                    );
                  }
                  return new Padding(
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
                                          borderRadius: BorderRadius.circular(20.0)
                                      ),
                                      child: Container(
                                        height: SizeConfig.screenHeight*0.8,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: SizeConfig.screenHeight*0.3,
                                                decoration: BoxDecoration(
                                                    borderRadius: new BorderRadius.only(
                                                        topLeft:  const  Radius.circular(20.0),
                                                        topRight: const  Radius.circular(20.0)),
                                                    image: DecorationImage(
                                                        image: NetworkImage(image),
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
                                                                child: Icon(FontAwesomeIcons.personBooth, color: Colors.blueAccent,),
                                                              ),
                                                              Text(Available+" / "+Participant, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),)
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
                                              SizedBox(
                                                child: Align(
                                                  alignment: Alignment.bottomCenter,
                                                  child: Container(
                                                    height: SizeConfig.screenHeight*0.1,
                                                    width: double.infinity,
                                                    child: RaisedButton.icon(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.only(
                                                            bottomLeft: const  Radius.circular(10.0),
                                                            bottomRight: const Radius.circular(10.0),
                                                          ),
                                                        ),
                                                        color: Colors.purple,
                                                        onPressed: (){
                                                          Navigator.push(context,MaterialPageRoute(builder: (context) => LocationMapNormal( docId: docID, eventName: title )));
                                                        },
                                                        icon: Icon(Icons.location_on, color: Colors.white,),
                                                        label: Text("View on Map", style: TextStyle(color: Colors.white))
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
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
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}