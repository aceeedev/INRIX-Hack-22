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

    Position position = await determinePosition();
    List<ProximityReminder> proximityReminders =
        await AppDatabase.instance.readAllProximityReminders();
    if (proximityReminders.isNotEmpty) {
      for (ProximityReminder proximityReminder in proximityReminders) {
        findDistanceFromAPI(
            position.longitude,
            position.latitude,
            proximityReminder.proximity,
            proximityReminder.longitude,
            proximityReminder.latitude);
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

  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerOneOffTask(backgroundTask, backgroundTask,
      initialDelay: Duration(seconds: timeBetweenBackgroundTasks));

  runApp(const MyApp());
}
