import 'package:flutter/material.dart';
import 'package:inrix_hack_22/pages/home_page.dart';
import 'package:inrix_hack_22/styles.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proximity Reminder',
      theme: ThemeData(
        primarySwatch: createMaterialColor(const Color(0xff0E366A)),
      ),
      home: const HomePage(),
    );
  }
}
