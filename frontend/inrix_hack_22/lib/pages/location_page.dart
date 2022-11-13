import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inrix_hack_22/backend/geolocation.dart';
import 'package:inrix_hack_22/models/proximity_reminder.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key, required this.proximityReminder})
      : super(key: key);
  final ProximityReminder proximityReminder;

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location Page")),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // add map here
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
