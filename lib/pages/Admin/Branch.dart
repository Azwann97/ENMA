import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enma/advance/HomeBg.dart';
import 'package:enma/advance/Sizeconfig.dart';
import 'package:enma/pages/Admin/AddBranch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AllBranch extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _AllBranchState();

}

class _AllBranchState extends State<AllBranch>{
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
                            child: Text("Registered UiTM Branches", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30.0),),
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
                                        builder: (BuildContext context) => new AddBranch()
                                    ));
                                  },
                                  icon: Icon(Icons.swap_vertical_circle, color: Colors.white,),
                                  label: Text("Add New", style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          StreamBuilder(
                            stream: Firestore.instance.collection("UiTMBranch").orderBy("BranchName", descending: true).snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                              if(!snapshot.hasData){
                                return new Container(
                                  child: Center(
                                    //child: Loading1(),
                                    child: Center(child: Text("There is no existing branch")),
                                  ),
                                );
                              }
                              return Container(
                                  height: 500.0,
                                  child: new AllBranchList(document: snapshot.data.documents,)
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

class AllBranchList extends StatelessWidget {
  AllBranchList({this.document});
  final List<DocumentSnapshot> document;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i){
        String name = document[i].data['BranchName'].toString();

        return Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Expanded(
                    child: Container(
                      width: 250,
                      height: 70,
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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