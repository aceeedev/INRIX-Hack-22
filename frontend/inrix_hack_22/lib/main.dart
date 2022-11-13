import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:inrix_hack_22/app.dart';

const backgroundTask = 'checkLocation';
int timeBetweenBackgroundTasks = 10;

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    Workmanager().registerOneOffTask(backgroundTask, backgroundTask,
        initialDelay: Duration(seconds: timeBetweenBackgroundTasks),
        existingWorkPolicy: ExistingWorkPolicy
            .append); // need to append to "loop" background tasks

    // runs when background worker goes off:
    print("---Background task executed: $backgroundTask---");
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
