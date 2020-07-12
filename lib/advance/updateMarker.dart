import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enma/pages/EventOrganizer/AddEvent.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'loading.dart';

class LocationMapEdit extends StatefulWidget {


  final String docId;
  LocationMapEdit({this.docId});

  @override
  _LocationMapEditState createState() => _LocationMapEditState();
}

class _LocationMapEditState extends State<LocationMapEdit> {

  CameraPosition _position = _kInitialPosition;
  MapType currentMapType  = MapType.normal;
  final Geolocator geolocator1 = Geolocator();                                         // new
  GoogleMapController mapController;
  List<Marker> allMarkers = [];
  LatLng currentLocation = LatLng(24.150, -110.32);
  LatLng get initialPos => currentLocation;
  Location location1 = new Location();
  LocationData currentLocationData1;                                                               // new
  Position currentPosition1;                                                                                              // new
  BitmapDescriptor icon;
  String address = '';                                                                                                                 // new
  bool buscando = false;

  setMarker() {
    return allMarkers;
  }

  getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.5),
        "assets/images/marker2.png");
    setState(() {
      this.icon = icon;
    });
  }


  void getMoveCamera() async {
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
        currentLocation.latitude,
        currentLocation.longitude
    );
  }

  void getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition();
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    currentLocation = LatLng(position.latitude,position.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(currentLocation));

  }

  void onCameraMove(CameraPosition position) async {
    buscando = false;
    currentLocation = position.target;
  }

  void onCreated(GoogleMapController controller) {
    mapController = controller;
  }

  onMapTypePressed() {
    setState(() {
      currentMapType = currentMapType == MapType.normal
          ? MapType.hybrid
          : MapType.normal;
    });
  }

  Firestore firestore = Firestore.instance;
//  Geoflutterfire geo = Geoflutterfire();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  setMarkers() {
    Firestore.instance.collection('Registered Event').where('docID', isEqualTo: widget.docId).getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i=0; i<docs.documents.length; i++) {
          initMarker(docs.documents[i].data, docs.documents[i].documentID);
        }
      }
    });
  }

  void initMarker(data, docID) {
    var markerIdVal = docID;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(data['LatLng'].latitude, data['LatLng'].longitude),
      infoWindow: InfoWindow(title: data['placeName'], snippet: data['category']),
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  @override
  void initState() {
    //getIcons();
    setMarkers();
    getUserLocation();
    super.initState();
  }

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(24.150, -110.32),
    zoom: 10,
  );

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Location', style: TextStyle( fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(24.142, -110.321),
              zoom: 17,
            ),
            onCameraIdle: () async {
              buscando = true;
              getMoveCamera();
            },
            onMapCreated: _onMapCreated,
            mapType: currentMapType,
            onCameraMove: onCameraMove ,
            zoomControlsEnabled: false,
            markers: Set<Marker>.of(markers.values),
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset('assets/images/marker.png', height: 50),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              color: Color(0xFFe3dfdf),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text('Move the map until the pin is directly over the NEW event location', style: TextStyle(fontSize: 15))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                  onPressed: _updateGeoPoint,
                  color: Colors.deepOrange,
                  //textColor: Colors.white,
                  child: Text("Replace Location",
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
      ),
    );
  }

  Future  _updateGeoPoint() async {
    DocumentReference docRef =  Firestore.instance.collection('Registered Event').document(widget.docId);
    docRef.updateData({
      "LatLng": new GeoPoint(currentLocation.latitude, currentLocation.longitude)
    })
        .whenComplete(() {
      print('Geolocation Added');
      Navigator.pop(context);
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Center(child: Text('The marker successfully updated', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            );
          });
    });
//      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
//      sharedPrefs.setString('long', currentLocation.longitude.toString());
//      sharedPrefs.setString('latit', currentLocation.latitude.toString());
  }

}