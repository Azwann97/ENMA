import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enma/advance/HomeBg.dart';
import 'package:enma/pages/Admin/AllUser.dart';
import 'package:enma/pages/Admin/AddBranch.dart';
import 'package:enma/pages/Admin/AddBuilding.dart';
import 'package:enma/pages/Admin/Branch.dart';
import 'package:enma/pages/Admin/Building.dart';
import 'package:enma/pages/Admin/Events.dart';
import 'package:enma/pages/root_page.dart';
import 'package:enma/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:enma/advance/Sizeconfig.dart';

import 'loading.dart';

class ruleBased extends StatefulWidget{
  final String uid;
  final String et;
  ruleBased({this.uid, this.et});

  @override
  _ruleBasedState createState() => _ruleBasedState();

}

class _ruleBasedState extends State<ruleBased> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    String UP;

    if(widget.et == 'SPORTS'){
      return Scaffold(
        body: Stack(
          children: <Widget>[
            HomeBg(screenHeight: MediaQuery.of(context).size.height),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: Container(
                  height: SizeConfig.screenHeight*1.0,
                  width: SizeConfig.screenWidth*1.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        height: SizeConfig.screenHeight*0.6,
                        width: SizeConfig.screenWidth*1.0,
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: .85,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          children: <Widget>[
                            UserMenu(
                              title: "EXTREME",
                              icon: FontAwesomeIcons.hiking,
                              press: () {
                                UP = "Extreme Sports";
                                print(UP);
                                updatePreference(up: UP);
                                Navigator.of(context).push(new MaterialPageRoute(
                                    builder: (BuildContext context) => new RootPage()
                                ));
                              },
                            ),
                            UserMenu(
                              title: "Not too Extreme",
                              icon: FontAwesomeIcons.futbol,
                              press: () {
                                UP = "Sports & Recreation";
                                print(UP);
                                updatePreference(up: UP);
                                Navigator.of(context).push(new MaterialPageRoute(
                                    builder: (BuildContext context) => new RootPage()
                                ));
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
    else if(widget.et == 'ICT'){
      return Scaffold(
        body: Stack(
          children: <Widget>[
            HomeBg(screenHeight: MediaQuery.of(context).size.height),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: Container(
                  height: SizeConfig.screenHeight*1.0,
                  width: SizeConfig.screenWidth*1.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        height: SizeConfig.screenHeight*0.6,
                        width: SizeConfig.screenWidth*1.0,
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: .85,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          children: <Widget>[
                            UserMenu(
                              title: "New Invention",
                              icon: FontAwesomeIcons.laptop,
                              press: () {
                                UP = "Technology & Information";
                                print(UP);
                                updatePreference(up: UP);
                                Navigator.of(context).push(new MaterialPageRoute(
                                    builder: (BuildContext context) => new RootPage()
                                ));
                              },
                            ),
                            UserMenu(
                              title: "Art & Design",
                              icon: FontAwesomeIcons.artstation,
                              press: () {
                                UP = "Multimedia";
                                print(UP);
                                updatePreference(up: UP);
                                Navigator.of(context).push(new MaterialPageRoute(
                                    builder: (BuildContext context) => new RootPage()
                                ));
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
    else if(widget.et == 'PLANTATION'){
      return Scaffold(
        body: Stack(
          children: <Widget>[
            HomeBg(screenHeight: MediaQuery.of(context).size.height),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: Container(
                  height: SizeConfig.screenHeight*1.0,
                  width: SizeConfig.screenWidth*1.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        height: SizeConfig.screenHeight*0.6,
                        width: SizeConfig.screenWidth*1.0,
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: .85,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          children: <Widget>[
                            UserMenu(
                              title: "Landscaping",
                              icon: FontAwesomeIcons.pagelines,
                              press: () {
                                UP = "Landscape";
                                print(UP);
                                updatePreference(up: UP);
                                Navigator.of(context).push(new MaterialPageRoute(
                                    builder: (BuildContext context) => new RootPage()
                                ));
                              },
                            ),
                            UserMenu(
                              title: "Just Plantation",
                              icon: FontAwesomeIcons.tree,
                              press: () {
                                UP = "Plantation";
                                print(UP);
                                updatePreference(up: UP);
                                Navigator.of(context).push(new MaterialPageRoute(
                                    builder: (BuildContext context) => new RootPage()
                                ));
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
    else if(widget.et == 'COMMUNITY'){
      return Scaffold(
        body: Stack(
          children: <Widget>[
            HomeBg(screenHeight: MediaQuery.of(context).size.height),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: Container(
                  height: SizeConfig.screenHeight*1.0,
                  width: SizeConfig.screenWidth*1.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        height: SizeConfig.screenHeight*0.6,
                        width: SizeConfig.screenWidth*1.0,
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: .85,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          children: <Widget>[
                            UserMenu(
                              title: "I like to take part in  charity",
                              icon: FontAwesomeIcons.users,
                              press: () {
                                UP = "Community Charity";
                                print(UP);
                                updatePreference(up: UP);
                                Navigator.of(context).push(new MaterialPageRoute(
                                    builder: (BuildContext context) => new RootPage()
                                ));
                              },
                            ),
                            UserMenu(
                              title: "I like to socialize",
                              icon: FontAwesomeIcons.comments,
                              press: () {
                                UP = "Social Activity";
                                print(UP);
                                updatePreference(up: UP);
                                Navigator.of(context).push(new MaterialPageRoute(
                                    builder: (BuildContext context) => new RootPage()
                                ));
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  Future updatePreference({String up}) async{
    DocumentReference docRef =  Firestore.instance.collection('users').document(widget.uid);
    docRef.updateData({
      "preference": up
    });
  }
}

class UserMenu extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function press;
  const UserMenu({
    Key key, this.title, this.icon, this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        //padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 100),
                blurRadius: 100,
                spreadRadius: 50,
                color: Colors.white10
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: press,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Icon(icon, size: 50, color: Colors.black,),
                  Spacer(),
                  Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.title.copyWith(fontSize: 13, color: Colors.black)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}