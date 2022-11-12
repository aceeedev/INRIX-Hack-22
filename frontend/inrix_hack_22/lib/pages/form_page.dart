import 'package:flutter/material.dart';
import 'package:inrix_hack_22/backend/database_manager.dart';
import 'package:inrix_hack_22/models/proximity_reminder.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  TextEditingController longTextController = TextEditingController();
  TextEditingController latTextController = TextEditingController();
  TextEditingController etaTextController = TextEditingController();
  TextEditingController phoneNumTextController = TextEditingController();
  TextEditingController phoneNameTextController = TextEditingController();

  @override
  void dispose() {
    // dispose of text controllers
    longTextController.dispose();
    latTextController.dispose();
    etaTextController.dispose();
    phoneNumTextController.dispose();
    phoneNameTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: createTextForms([
            {'controller': longTextController, 'text': 'Longitude'},
            {'controller': latTextController, 'text': 'Latitude'},
            {'controller': etaTextController, 'text': 'Proximity'},
            {'controller': phoneNumTextController, 'text': 'Phone Number'},
            {'controller': phoneNameTextController, 'text': 'Phone Number Name'}
          ]),
        ),
      ),
    );
  }

  void sendForm() async {
    // example of getting text from long: longTextController.text
    ProximityReminder proximityReminder = ProximityReminder(
      longitude: double.parse(longTextController.text),
      latitude: double.parse(latTextController.text),
      proximity: double.parse(etaTextController.text),
      phoneNumber: phoneNumTextController.text,
      phoneNumberName: phoneNameTextController.text,
    );

    await AppDatabase.instance.createProximityReminder(proximityReminder);

    print((await AppDatabase.instance.readAllProximityReminders()).length);
  }

  List<Widget> createTextForms(List<Map<String, dynamic>> inputFields) {
    List<Widget> listOfTextFields = [];

    for (Map<String, dynamic> inputField in inputFields) {
      listOfTextFields.add(Text(
        inputField['text'],
        style: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ));
      listOfTextFields.add(Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: TextField(
          controller: inputField['controller'],
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Please Input the ${inputField['text']}',
          ),
        ),
      ));
    }

    listOfTextFields
        .add(ElevatedButton(onPressed: sendForm, child: const Icon(Icons.add)));

    return listOfTextFields;
  }
}
