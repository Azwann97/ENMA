import 'package:enma/advance/HomeBg.dart';
import 'package:enma/pages/EventOrganizer/ALlEvent.dart';
import 'package:enma/pages/EventOrganizer/DashboardO.dart';
import 'package:enma/pages/EventOrganizer/History.dart';
import 'package:enma/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:enma/advance/Sizeconfig.dart';


class AdminOrg extends StatefulWidget{
  final String uid;
  final String contact;
  AdminOrg({this.uid, this.contact});

  @override
  _AdminOrgState createState() => _AdminOrgState();

}

class _AdminOrgState extends State<AdminOrg>{
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
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Text("Events", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32.0),
                              child: Text("Event Organizer", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30.0),),
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
                                    label: Text("Switch to Admin", style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                              ),
                            ),
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
                              title: "My Event",
                              icon: FontAwesomeIcons.pen,
                              press: () {
                                Navigator.of(context).push(new MaterialPageRoute(
                                    builder: (BuildContext context) => new DashboardO(uid: widget.uid, contact: widget.contact)
                                ));
                              },
                            ),
                            UserMenu(
                              title: "History",
                              icon: FontAwesomeIcons.history,
                              press: () {
                                Navigator.of(context).push(new MaterialPageRoute(
                                    builder: (BuildContext context) => new History(uid: widget.uid,)
                                ));
                              },
                            ),
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