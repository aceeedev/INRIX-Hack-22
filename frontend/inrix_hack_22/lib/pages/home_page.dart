import 'package:flutter/material.dart';
import 'package:inrix_hack_22/models/proximity_reminder.dart';
import 'package:inrix_hack_22/pages/form_page.dart';
import 'package:inrix_hack_22/pages/location_page.dart';
import 'package:inrix_hack_22/backend/database_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//new code

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : proximityReminders.isEmpty
                ? const Text(
                    'No Proximity Reminders',
                  )
                : buildProximityReminders(),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const FormPage()
            ));
            refreshProximityReminders();
          }),

    );
  }

  Widget buildProximityReminders() => GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          childAspectRatio: 0.5),
      itemCount: proximityReminders.length,
      itemBuilder: (context, index) {
        ProximityReminder proximityReminder = proximityReminders[index];

        return Card(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Spacer(),
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
            ]),
        );
      });
}