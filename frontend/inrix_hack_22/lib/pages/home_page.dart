import 'package:flutter/material.dart';
import 'package:inrix_hack_22/models/proximity_reminder.dart';
import 'package:inrix_hack_22/pages/form_page.dart';
import 'package:inrix_hack_22/backend/database_manager.dart';
import 'package:inrix_hack_22/pages/map_page.dart';
import 'package:inrix_hack_22/globals.dart' as globals;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<ProximityReminder> proximityReminders;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshProximityReminders();
  }

  @override
  void dispose() {
    AppDatabase.instance.close();

    super.dispose();
  }

  Future refreshProximityReminders() async {
    setState(() => isLoading = true);

    proximityReminders = await AppDatabase.instance.readAllProximityReminders();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    late GoogleMapController mapController;

    final LatLng _center = const LatLng(45.521563, -122.677433);

    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
      // Center(
      //   child: isLoading
      //       ? CircularProgressIndicator()
      //       : proximityReminders.isEmpty
      //           ? Text(
      //               globals.homeLocation,
      //             )
      //           : buildProximityReminders(),
      // ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const FormPage()));
            refreshProximityReminders();
          }),
    );
  }

  Widget buildProximityReminders() => ListView.builder(
      itemCount: proximityReminders.length,
      itemBuilder: (context, index) {
        ProximityReminder proximityReminder = proximityReminders[index];

        return Card(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              proximityReminder.phoneNumberName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Phone: ${proximityReminder.phoneNumber}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Longitute: ${proximityReminder.longitude}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Latitude: ${proximityReminder.latitude}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                int? id = proximityReminder.id;
                if (id != null) {
                  await AppDatabase.instance.deleteProximityReminder(id);
                }
                refreshProximityReminders();
              },
            )
          ]),
        );
      });
}
