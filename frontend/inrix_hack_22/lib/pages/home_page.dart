import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:inrix_hack_22/models/proximity_reminder.dart';
import 'package:inrix_hack_22/pages/form_page.dart';
import 'package:inrix_hack_22/pages/location_page.dart';
import 'package:inrix_hack_22/backend/database_manager.dart';

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
    print('Length is: ${proximityReminders.length}');

    setState(() => isLoading = false);
  }

  Future<void> askForPermission() async {
    var status = await Permission.locationAlways.status;
    if (!status.isGranted) {
      // request access to the permission
      await Permission.location.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : proximityReminders.isEmpty
                ? const Text(
                    'Add a location to start!',
                  )
                : buildProximityReminders(),
      ),
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

        return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    LocationPage(proximityReminder: proximityReminder),
              ));
            },
            child: Card(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        'Address: ${proximityReminder.latitude}',
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
                          await AppDatabase.instance
                              .deleteProximityReminder(id);
                        }
                        refreshProximityReminders();
                      },
                    ),
                  ]),
            ));
      });
}
