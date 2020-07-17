import 'package:enma/advance/HomeBg.dart';
import 'package:enma/pages/Admin/AllUser.dart';
import 'package:enma/pages/Admin/AddBranch.dart';
import 'package:enma/pages/Admin/AddBuilding.dart';
import 'package:enma/pages/Admin/Branch.dart';
import 'package:enma/pages/Admin/Building.dart';
import 'package:enma/pages/Admin/Events.dart';
import 'package:enma/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'AdminNormal.dart';
import 'AdminOrg.dart';
import 'package:enma/advance/Sizeconfig.dart';

class AdminHome extends StatefulWidget{
  final String uid;
  final String contact;
  final String up;

  AdminHome({this.uid, this.contact, this.up});

  @override
  _AdminHomeState createState() => _AdminHomeState();

}

class _AdminHomeState extends State<AdminHome>{
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          HomeBg(screenHeight: MediaQuery.of(context).size.height),
          SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  height: SizeConfig.screenHeight*1.0,
                  width: SizeConfig.screenWidth*1.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: SizeConfig.screenHeight*0.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32.0),
                              child: Row(
                                children: <Widget>[
                                  Text("Events", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                                  Spacer(),
                                  IconButton(
                                      icon: Icon(Icons.exit_to_app, color: Colors.white, size: 30.0,),
                                      onPressed: () async {
                                        await _auth.signOut();
                                      }
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32.0),
                              child: Text("Admin Page", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30.0),),
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
                                          builder: (BuildContext context) => new AdminOrg(uid: widget.uid, contact: widget.contact)
                                      ));
                                    },
                                    icon: Icon(Icons.swap_vertical_circle, color: Colors.white,),
                                    label: Text("Switch to Event Organizer", style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                              ),
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
                                          builder: (BuildContext context) => new AdminNormal(uid: widget.uid, up: widget.up)
                                      ));
                                    },
                                    icon: Icon(Icons.swap_vertical_circle, color: Colors.white,),
                                    label: Text("Switch to Normal User", style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
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
                              title: "All Users",
                              icon: FontAwesomeIcons.userAlt,
                              press: () {
                                Navigator.of(context).push(new MaterialPageRoute(
                                    builder: (BuildContext context) => new AllUser()
                                ));
                              },
                            ),
                            /*
                            UserMenu(
                              title: "All Event",
                              icon: FontAwesomeIcons.book,
                              press: () {
                                Navigator.of(context).push(new MaterialPageRoute(
                                    builder: (BuildContext context) => new AllEvents()
                                ));
                              },
                            ),*/
                            UserMenu(
                              title: "Registered UiTM Branch",
                              icon: FontAwesomeIcons.mapMarked,
                              press: () {
                                Navigator.of(context).push(new MaterialPageRoute(
                                    builder: (BuildContext context) => new AllBranch()
                                ));
                              },
                            ),
                            UserMenu(
                              title: "All Building",
                              icon: FontAwesomeIcons.building,
                              press: () {
                                Navigator.of(context).push(new MaterialPageRoute(
                                    builder: (BuildContext context) => new AllBuilding()
                                ));
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
          )
        ],
      ),
    );
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
                offset: Offset(0, 17),
                blurRadius: 17,
                spreadRadius: -23,
                color: Colors.grey
            )
          ],
          color: Colors.deepOrangeAccent,
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
                  Icon(icon, size: 50, color: Colors.white,),
                  Spacer(),
                  Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.title.copyWith(fontSize: 13, color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}