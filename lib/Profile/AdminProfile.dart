import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enma/Profile/EditProfile.dart';
import 'package:enma/Profile/EditProfileA.dart';
import 'package:enma/advance/HomeBg.dart';
import 'package:enma/advance/Sizeconfig.dart';
import 'package:enma/advance/loading1.dart';
import 'package:enma/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../pages/EventOrganizer/OrgHome.dart';
import 'EditProfile.dart';

class AdminProfile extends StatefulWidget{
  final String uid;
  AdminProfile({this.uid});
  @override
  State<StatefulWidget> createState() => new _AdminProfileState();

}

class _AdminProfileState extends State<AdminProfile>{
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
              height: double.infinity,
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
                    height: SizeConfig.screenHeight*0.1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("User Profile", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30.0),),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          StreamBuilder(
                            stream: Firestore.instance.collection("users").where("user id", isEqualTo: widget.uid).snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                              if(!snapshot.hasData){
                                return new Container(
                                  child: Center(
                                    child: Loading1(),
                                  ),
                                );
                              }
                              return Container(
                                  width: SizeConfig.screenWidth*0.95,
                                  height: SizeConfig.blockSizeHorizontal*143,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        topRight: Radius.circular(50)
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
                                  child: new UserDetails(document: snapshot.data.documents)
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),

            ),
          ),
        ],
      ),
    );
  }
}

class UserDetails extends StatelessWidget {
  UserDetails({this.document});
  final List<DocumentSnapshot> document;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i){
        String Name = document[i].data['name'].toString();
        //String id = document[i].data['UiTM id'].toString();
        String email = document[i].data['email'].toString();
        //String gender = document[i].data['gender'].toString();
        String Contact = document[i].data['Contact Number'].toString();
        //String Faculty = document[i].data['Faculty'].toString();
        String UserImage = document[i].data['User Image'].toString();

        return Container(
          child: Column(
            children: <Widget>[
              Container(
                height: SizeConfig.screenHeight*0.05,
              ),
              Container(
                height: SizeConfig.screenHeight*0.6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height:200,
                        width:200,
                        margin: EdgeInsets.only(top: 30, bottom: 20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 3, color: Colors.blueGrey),
                          image: DecorationImage(
                              image: NetworkImage(UserImage),
                              fit: BoxFit.cover),
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
                            new Expanded(child: Text(Name, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),))
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
                            new Expanded(child: Text(email, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),))
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
                            new Expanded(child: Text(Contact, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: SizeConfig.screenHeight*0.1,
                width: double.infinity,
                child: RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    color: Colors.blueAccent,
                    onPressed: (){
                      Navigator.pop(context);
                      //print(UserImage);
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new EditProfileA(
                            name: Name,
                            Email: email,
                            contact : Contact,
                            UImage : UserImage,
                            index: document[i].reference,
                          )
                      ));
                    },
                    icon: Icon(FontAwesomeIcons.edit, color: Colors.white,),
                    label: Text("Edit", style: TextStyle(color: Colors.white))
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}