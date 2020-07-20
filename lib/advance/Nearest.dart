import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Nearest extends StatefulWidget {

  final String uid;

 Nearest({this.uid});

  @override
  _NearestState createState() => _NearestState();
}

class _NearestState extends State<Nearest> {

  CameraPosition _position = _kInitialPosition;
  MapType currentMapType = MapType.normal;
  final Geolocator geolocator = Geolocator(); // new
  GoogleMapController mapController;
  List<Marker> allMarkers = [];
  LatLng currentLocation = LatLng(24.150, -110.32);

  LatLng get initialPos => currentLocation;
  Location location = new Location();
  LocationData currentLocationData; // new
  Position currentPosition; // new
  BitmapDescriptor icon;
  String address = ''; // new
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
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
        position.latitude, position.longitude);
    currentLocation = LatLng(position.latitude, position.longitude);
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
    firestore.collection('Registered Event').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; i++) {
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
      infoWindow: InfoWindow(
          title: data['Event Name'], snippet: data['Event Type']),
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
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(
            'View Nearest Events', style: TextStyle(fontWeight: FontWeight.bold)),
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
            onCameraMove: onCameraMove,
            zoomControlsEnabled: false,
            markers: Set<Marker>.of(markers.values),
          ),
          /*Align(
            alignment: Alignment.center,
            child: Image.asset('assets/images/marker.png', height: 50),
          ),*/
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
                        Expanded(child: Text(
                            'You can move the map to have a look on nearest available events ',
                            style: TextStyle(fontSize: 15))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 20,
              right: MediaQuery
                  .of(context)
                  .size
                  .width / 26,
              child: ButtonTheme(
                height: 55,
                minWidth: 60,
                child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(3.0),
                        side: BorderSide(color: Colors.red)),
                    onPressed: onMapTypePressed,
                    color: Colors.red,
                    //textColor: Colors.white,
                    child: Icon(Icons.map, color: Colors.white, size: 35)
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
}