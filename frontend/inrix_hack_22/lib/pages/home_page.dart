import 'package:flutter/material.dart';
import 'package:inrix_hack_22/pages/form_page.dart';
import 'package:inrix_hack_22/pages/location_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Center(
          child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LocationPage()));
        },
        child: const Text('This is the device\'s location'),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const FormPage())),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
