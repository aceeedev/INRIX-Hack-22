import 'package:flutter/material.dart';
import 'package:inrix_hack_22/pages/home_page.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return const MaterialApp(
  //     title: 'Flutter Location Demo',
  //     debugShowCheckedModeBanner: false,
  //     home: HomePage(),
  //   );
  // }

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location Page")),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('LAT: '),
              const Text('LNG: '),
              const Text('ADDRESS: '),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Get Current Location"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
