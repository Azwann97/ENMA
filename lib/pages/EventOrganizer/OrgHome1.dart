import 'package:enma/advance/HomeBg.dart';
import 'package:enma/pages/EventOrganizer/OrgHome.dart';
import 'package:enma/pages/NormUser/EventRecommended.dart';
import 'package:enma/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:enma/pages/NormUser/All.dart';
import 'package:enma/advance/Sizeconfig.dart';
import '../../Profile/Profile.dart';
import 'package:enma/pages/NormUser/Join.dart';


class OrgHome1 extends StatefulWidget{
  final String uid;
  final String AJE;
  final String up;

  OrgHome1({this.uid, this. AJE, this.up});

  @override
  _OrgHome1State createState() => _OrgHome1State();

}

class _OrgHome1State extends State<OrgHome1>{
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          HomeBg(screenHeight: MediaQuery.of(context).size.height),
          SafeArea(
            child: Container(
              height: SizeConfig.screenHeight*1.0,
              width: SizeConfig.screenWidth*1.0,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: SizeConfig.screenHeight*0.3,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Row(
                              children: <Widget>[
                                Text("Events", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                                Spacer(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Text("User Page", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30.0),),
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
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.swap_vertical_circle, color: Colors.white,),
                                  label: Text("Switch Account", style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                          title: "Event Recommendation",
                          icon: FontAwesomeIcons.thumbsUp,
                          press: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) => new EventRecommended(uid: widget.uid, up:widget.up)));
                          },
                        ),
                        UserMenu(
                          title: "View All Event",
                          icon: FontAwesomeIcons.search,
                          press: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) => new All(uid: widget.uid,)));
                          },
                        ),
                        UserMenu(
                          title: "Joined Event",
                          icon: FontAwesomeIcons.bookmark,
                          press: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) => new Join(uid: widget.uid,)));
                          },
                        ),
                        UserMenu(
                          title: "View Profile",
                          icon: FontAwesomeIcons.user,
                          press: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) => new Profile(uid: widget.uid,)));
                          },
                        )
                      ],
                    ),
                  )
                ],
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