import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covac/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_launcher/maps_launcher.dart';

class MapPage extends StatefulWidget {
  final uid;
  MapPage(this.uid);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  double finalLat, finalLong;
  Position position;
  GoogleMapController googleMapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void getMarkers(double lat, double long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker _marker = Marker(
        markerId: markerId,
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));

    setState(() {
      markers[markerId] = _marker;
    });
  }

  void saveToDB() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc('${widget.uid}')
        .update({'latitude': finalLat, 'longitude': finalLong});

    Navigator.pop(context, true);
  }

  void getCurrentLocation() async {
    Position currentPosition =
        await GeolocatorPlatform.instance.getCurrentPosition();
    setState(() {
      position = currentPosition;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Pin your address",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: kPrimaryColor,
          elevation: 0,
          centerTitle: true,
          textTheme: Theme.of(context).textTheme,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
                mapToolbarEnabled: true,
                onTap: (tapped) {
                  markers.isEmpty
                      ? getMarkers(tapped.latitude, tapped.longitude)
                      : markers.clear();
                  getMarkers(tapped.latitude, tapped.longitude);

                  setState(() {
                    finalLat = tapped.latitude;
                    finalLong = tapped.longitude;
                  });
                  print(tapped.latitude.toString() +
                      " " +
                      tapped.longitude.toString());
                },
                onMapCreated: (GoogleMapController controller) {
                  setState(() {
                    googleMapController = controller;
                  });
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(12.313243157514334, 76.61402869200367),
                    zoom: 15.0),
                markers: Set<Marker>.of(markers.values)),
            Container(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                    onPressed: saveToDB,
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      primary: kPrimaryColor,
                    ))),
          ],
        ));
  }
}
