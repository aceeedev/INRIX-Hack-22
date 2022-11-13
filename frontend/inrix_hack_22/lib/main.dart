import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';
import 'package:inrix_hack_22/app.dart';
import 'package:inrix_hack_22/models/proximity_reminder.dart';
import 'package:inrix_hack_22/backend/database_manager.dart';
import 'package:inrix_hack_22/backend/geolocation.dart';
import 'package:inrix_hack_22/backend/flask_api.dart';

const backgroundTask = 'checkLocation';
int timeBetweenBackgroundTasks = 10;

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // runs when background worker goes off:
    print("---Background task executed: $backgroundTask---");

    List<ProximityReminder> proximityReminders =
        await AppDatabase.instance.readAllProximityReminders();
    if (proximityReminders.isNotEmpty) {
      Position position = await determinePosition();

      for (ProximityReminder proximityReminder in proximityReminders) {
        final insideMap = await checkIfInsideArea(
            position.longitude,
            position.latitude,
            proximityReminder.proximity,
            proximityReminder.longitude,
            proximityReminder.latitude);

        print(insideMap['inside']);
        if (insideMap['inside'] == false) {
          sendMessage(
              "${proximityReminder.phoneNumberName}: Dependent is out of the ring",
              proximityReminder.phoneNumber);
        }
      }
    }

    // create another background task
    Workmanager().registerOneOffTask(backgroundTask, backgroundTask,
        initialDelay: Duration(seconds: timeBetweenBackgroundTasks),
        existingWorkPolicy: ExistingWorkPolicy
            .append); // need to append to "loop" background tasks
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
  Workmanager().cancelAll();

  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerOneOffTask(backgroundTask, backgroundTask,
      initialDelay: Duration(seconds: timeBetweenBackgroundTasks));
}
