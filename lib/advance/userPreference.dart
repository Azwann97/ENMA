import 'package:enma/advance/HomeBg.dart';
import 'package:enma/advance/Rule-Based.dart';
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
import 'package:enma/advance/Sizeconfig.dart';

class userPreference extends StatefulWidget{
  final String uid;

  userPreference({this.uid});

  @override
  _userPreferenceState createState() => _userPreferenceState();

}

class _userPreferenceState extends State<userPreference>{
  final AuthService _auth = AuthService();
  String ET;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

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
                                title: "SPORTS",
                                icon: FontAwesomeIcons.swimmer,
                                press: () {
                                  ET = "SPORTS";
                                  print(ET);
                                  Navigator.of(context).push(new MaterialPageRoute(
                                      builder: (BuildContext context) => new ruleBased(uid: widget.uid, et: ET)
                                  ));
                                },
                              ),
                              UserMenu(
                                title: "ICT",
                                icon: FontAwesomeIcons.laptopCode,
                                press: () {
                                  ET = "ICT";
                                  print(ET);
                                  Navigator.of(context).push(new MaterialPageRoute(
                                      builder: (BuildContext context) => new ruleBased(uid: widget.uid, et: ET)
                                  ));
                                },
                              ),
                              UserMenu(
                                title: "PLANTATION",
                                icon: FontAwesomeIcons.tree,
                                press: () {
                                  ET = "PLANTATION";
                                  print(ET);
                                  Navigator.of(context).push(new MaterialPageRoute(
                                      builder: (BuildContext context) => new ruleBased(uid: widget.uid, et: ET)
                                  ));
                                },
                              ),
                              UserMenu(
                                title: "COMMUNITY",
                                icon: FontAwesomeIcons.peopleArrows,
                                press: () {
                                  ET = "COMMUNITY";
                                  print(ET);
                                  Navigator.of(context).push(new MaterialPageRoute(
                                      builder: (BuildContext context) => new ruleBased(uid: widget.uid, et: ET)
                                  ));
                                },
                              )
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