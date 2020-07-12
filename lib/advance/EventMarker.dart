
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enma/pages/EventOrganizer/AddEvent.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class FireMap extends StatefulWidget {
  final String contact;
  final String uid;
  final String eventName;
  final DateTime eventDate;
  final String eventTime;
  final String image;
  final String status;
  final String uitm;
  final int part;
  final String type;
  final String venue;

  FireMap({this.contact, this.uid, this.eventName, this.eventDate, this.eventTime, this.image, this.status, this.uitm, this.part, this.type, this.venue});

  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {

  CameraPosition _position = _kInitialPosition;
  MapType currentMapType  = MapType.normal;
  final Geolocator geolocator = Geolocator();                                         // new
  GoogleMapController mapController;
  List<Marker> allMarkers = [];
  LatLng currentLocation = LatLng(24.150, -110.32);
  LatLng get initialPos => currentLocation;
  Location location = new Location();
  LocationData currentLocationData;                                                               // new
  Position currentPosition;                                                                                              // new
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
  Geoflutterfire geo = Geoflutterfire();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  setMarkers() {
    firestore.collection('locations').getDocuments().then((docs) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Location', style: TextStyle( fontWeight: FontWeight.bold)),
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
                        Expanded(child: Text('Move the map until the pin is directly over '+widget.eventName+' location', style: TextStyle(fontSize: 15))),
                        //Text(widget.eventName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  onPressed: _addGeoPoint,
                  color: Colors.deepOrange,
                  //textColor: Colors.white,
                  child: Text("Set Location",
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

  void _updateCameraPosition(CameraPosition position) {
    setState(() {
      _position = position;
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Future  _addGeoPoint() async {

    Firestore.instance.runTransaction((Transaction transaction) async {
      StorageReference ref = FirebaseStorage.instance.ref().child(filename);
      StorageUploadTask uploadTask = ref.putFile(image);
      var ImageURL = await (await uploadTask.onComplete).ref.getDownloadURL();
      var url = ImageURL.toString();

    DocumentReference docRef =  Firestore.instance.collection('Registered Event').document();
    docRef.setData({
      "docID" : docRef.documentID,
      "User Id" : widget.uid,
      "Event Name" : widget.eventName,
      "Date": widget.eventDate,
      "Time Start" : widget.eventTime,
      "Venue" : widget.venue,
      "Image" : url,
      "Event Status" : widget.status,
      "UiTM" : widget.uitm,
      "Number of Participant Allowed" : widget.part,
      "Event Type" : widget.type,
      "Availability" : widget.part,
      "Contact Number" : widget.contact,
      "LatLng": new GeoPoint(currentLocation.latitude, currentLocation.longitude)
    })
        .whenComplete(() {
      print('Geolocation Added');
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      //Navigator.push(context,MaterialPageRoute(builder: (context) => LocationPage(uid: widget.userid, docID: docRef.documentID)));
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
              title: Center(child: Text('Event successfully Added', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            );
          });
    });
    });
//      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
//      sharedPrefs.setString('long', currentLocation.longitude.toString());
//      sharedPrefs.setString('latit', currentLocation.latitude.toString());
  }
}