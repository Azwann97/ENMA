import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enma/advance/HomeBg.dart';
import 'package:enma/advance/Sizeconfig.dart';
import 'package:enma/advance/loading1.dart';
import 'package:enma/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AllEvents extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _AllEventsState();

}

class _AllEventsState extends State<AllEvents>{
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
                            stream: Firestore.instance.collection("Registered Event").where('Date', isGreaterThanOrEqualTo: DateTime.now()).orderBy("Date", descending: true).snapshots(),
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
                                  child: new AllEventsList(document: snapshot.data.documents,)
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
      ),
    );
  }
}

class AllEventsList extends StatelessWidget {
  AllEventsList({this.document});
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
        //String Status = document[i].data['Event Status'].toString();
        String Participant = document[i].data['Number of Participant Allowed'].toString();
        String image = document[i].data['Image'].toString();
        String contact = document[i].data['Contact Number'].toString();
        String TOE = document[i].data['Event Type'].toString();
        String Available = document[i].data['Availability'].toString();
        int Availability = document[i].data['Availability'];

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
            )
        );
      },
    );
  }
}