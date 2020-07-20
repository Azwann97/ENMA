import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enma/advance/updateMarker.dart';
import 'package:enma/pages/EventOrganizer/AddEvent.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'loading.dart';

class LocationMap extends StatefulWidget {

  final String docId ;
  final String eventName ;

  LocationMap({this.docId, this.eventName});

  @override
  _LocationMapState createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
  MapType currentMapType  = MapType.normal;

  setMarkers() async {
    await Firestore.instance.collection('Registered Event').where('docID', isEqualTo: widget.docId).getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i=0; i<docs.documents.length; i++) {
          initMarker(docs.documents[i].data, docs.documents[i].documentID);
        }
      }
    });
  }

  void initMarker(data, docId) {
    var markerIdVal = docId;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(data["LatLng"].latitude, data["LatLng"].longitude),
      //infoWindow: InfoWindow(title: data['placeName'], snippet: data['category']),
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  onMapTypePressed() {
    setState(() {
      currentMapType = currentMapType == MapType.normal
          ? MapType.hybrid
          : MapType.normal;
    });
  }

  @override
  void initState() {
    setMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text('Map View', style: TextStyle( fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('Registered Event').document(widget.docId).snapshots(),
        builder:(context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }
          return  Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(snapshot.data["LatLng"].latitude,snapshot.data["LatLng"].longitude),
                  zoom: 17,
                ),
//              onCameraIdle: () async {
//                buscando = true;
//                getMoveCamera();
//              },
                //onMapCreated: _onMapCreated,
                mapType: currentMapType,
                //onCameraMove: onCameraMove ,
                zoomControlsEnabled: false,
                markers: Set<Marker>.of(markers.values),
              ),
              Positioned(
                  bottom: 20,
                  left: MediaQuery.of(context).size.width /26,
                  child: ButtonTheme(
                    height: 55,
                    minWidth: 300,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(3.0),
                          side: BorderSide(color: Colors.deepOrange)),
                      onPressed:  () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => LocationMapEdit( docId: widget.docId)));
                      },
                      color: Colors.deepOrange,
                      //textColor: Colors.white,
                      child: Text("Update New Marker",
                          style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold )),
                    ),
                  )
              ),
              Positioned(
                  bottom: 20,
                  right: MediaQuery.of(context).size.width /26,
                  child: ButtonTheme(
                    height: 55,
                    minWidth: 60,
                    child: RaisedButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(3.0),
                            side: BorderSide(color: Colors.deepOrange)),
                        onPressed:onMapTypePressed,
                        color: Colors.deepOrange,
                        //textColor: Colors.white,
                        child:  Icon(Icons.map, color: Colors.white, size: 35)
                    ),
                  )
              ),
            ],
          );
        },
      ),
    );
  }
}