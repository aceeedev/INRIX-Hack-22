import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:inrix_hack_22/models/proximity_reminder.dart';
import 'dart:collection';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inrix_hack_22/backend/flask_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inrix_hack_22/app.dart';
import 'package:inrix_hack_22/models/proximity_reminder.dart';
import 'package:inrix_hack_22/backend/database_manager.dart';
import 'package:inrix_hack_22/backend/geolocation.dart';
import 'package:workmanager/workmanager.dart';

// late Position position;
// void determinePositionWrapper() async {
//   position = await determinePosition();
//   print(position);
// }

// late Map coords;
// void checkIfInsideAreaWrapper(myLon, myLat, timeTresh, lon, lat) async {
//   coords = await checkIfInsideArea(myLon, myLat, timeTresh, lon, lat);
// }

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key, required this.proximityReminder})
      : super(key: key);
  final ProximityReminder proximityReminder;

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late GoogleMapController mapController;
  late LatLng _center;
  Set<Polygon> _polygon = HashSet<Polygon>();
  late List<LatLng> points;

  @override
  void initState() {
    super.initState();
    _center = LatLng(
        widget.proximityReminder.latitude, widget.proximityReminder.longitude);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPoints();
    });

    // initialize the polygon
    _polygon.add(Polygon(
      // given polygonId
      polygonId: PolygonId('1'),
      // initialize the list of points to display polygon
      points: points,
      // given color to polygon
      fillColor: Colors.green.withOpacity(0.3),
      // given border color to polygon
      strokeColor: Colors.green,
      geodesic: true,
      // given width of border
      strokeWidth: 4,
    ));
  }

  getPoints() async {
    Position pos = await determinePosition();
    var coords = (await checkIfInsideArea(
        pos.longitude,
        pos.latitude,
        widget.proximityReminder.proximity,
        widget.proximityReminder.longitude,
        widget.proximityReminder.latitude))['coord'];

    List<LatLng> points = [];
    for (int i = 0; i < coords.length; i++) {
      points.add(LatLng(coords[i][0], coords[i][1]));
    }

    this.points = points;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    // this is a list of polygons around santa clara for demo
    // List<LatLng> points = [
    //   LatLng(37.350264, -121.943206),
    //   LatLng(37.351582, -121.939321),
    //   LatLng(37.348064, -121.937111),
    //   LatLng(37.346617, -121.941263),
    // ];
    return Scaffold(
      appBar: AppBar(title: const Text("Location Page")),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.9,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 16.0,
                  ),
                  polygons: _polygon,
                ),
              ),
              Text('Address: ${widget.proximityReminder.address}'),
              Text('Phone Number: ${widget.proximityReminder.phoneNumber}'),
              Text(
                  'Phone Number Name: ${widget.proximityReminder.phoneNumberName}'),
            ],
          ),
        ),
      ),
    );
  }
}
