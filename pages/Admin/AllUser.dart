import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enma/advance/HomeBg.dart';
import 'package:enma/advance/Sizeconfig.dart';
import 'package:enma/advance/loading1.dart';
import 'package:enma/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AllUser extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _AllUserState();

}

class _AllUserState extends State<AllUser>{
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
                            child: Text("All Users", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30.0),),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          StreamBuilder(
                            stream: Firestore.instance.collection("users").orderBy("name", descending: true).snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                              if(!snapshot.hasData){
                                return new Container(
                                  child: Center(
                                    //child: Loading1(),
                                    child: Center(child: Text("There is no existing user")),
                                  ),
                                );
                              }
                              return Container(
                                  height: 500.0,
                                  child: new AllUserList(document: snapshot.data.documents,)
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

class AllUserList extends StatelessWidget {
  AllUserList({this.document});
  final List<DocumentSnapshot> document;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i){
        String name = document[i].data['name'].toString();
        String UiTMId = document[i].data['UiTM id'].toString();
        String Image = document[i].data['User Image'].toString();
        String Faculty = document[i].data['Faculty'].toString();
        String contact = document[i].data['Contact Number'].toString();
        String gender = document[i].data['gender'].toString();
        String email = document[i].data['email'].toString();
        String accountType = document[i].data['Account Type'].toString();



        return Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Expanded(
                  child: Container(
                      width: 250,
                      height: 350,
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
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Container(
                        width: 250,
                        height: 350,
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
                              height: 350,
                              width: 150,
                              decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.only(
                                      topLeft:  const  Radius.circular(10.0),
                                      bottomLeft: const  Radius.circular(10.0)),
                                  image: DecorationImage(
                                    image: NetworkImage(Image),
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
                                        child: Text(name, style: new TextStyle(fontSize: 30.0, letterSpacing: 1.0,),),
                                      ),
                                      new Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(right: 16.0, bottom: 10.0),
                                            child: Icon(Icons.perm_identity, color: Colors.blueAccent,),
                                          ),
                                          new Expanded(child: Text(UiTMId, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),)),
                                        ],
                                      ),
                                      new Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(right: 16.0, bottom: 10.0),
                                            child: Icon(Icons.mail, color: Colors.blueAccent,),
                                          ),
                                          new Expanded(child: Text(email, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),))
                                        ],
                                      ),
                                      new Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(right: 16.0, bottom: 10.0),
                                            child: Icon(FontAwesomeIcons.book, color: Colors.blueAccent,),
                                          ),
                                          Expanded(child: Text(Faculty, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),))
                                        ],
                                      ),
                                      new Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(right: 16.0, bottom: 10.0),
                                            child: Icon(FontAwesomeIcons.venusMars, color: Colors.blueAccent,),
                                          ),
                                          Expanded(child: Text(gender, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),))
                                        ],
                                      ),
                                      new Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(right: 16.0, bottom: 10.0),
                                            child: Icon(FontAwesomeIcons.phone, color: Colors.blueAccent,),
                                          ),
                                          Expanded(child: Text(contact, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),))
                                        ],
                                      ),
                                      new Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(right: 16.0, bottom: 10.0),
                                            child: Icon(FontAwesomeIcons.bookmark, color: Colors.blueAccent,),
                                          ),
                                          Expanded(child: Text(accountType, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),))
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