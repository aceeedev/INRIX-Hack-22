import 'package:flutter/material.dart';
import 'package:inrix_hack_22/backend/database_manager.dart';
import 'package:inrix_hack_22/models/proximity_reminder.dart';
import 'package:inrix_hack_22/globals.dart' as globals;

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final longTextController = TextEditingController();
  final latTextController = TextEditingController();
  final etaTextController = TextEditingController();
  final phoneNumTextController = TextEditingController();
  final phoneNameTextController = TextEditingController();

  final formKey = GlobalKey<FormState>();

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Form Page"),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: createTextForms([
              {
                'controller': longTextController,
                'text': 'Longitude',
                'validator': doubleValidator
              },
              {
                'controller': latTextController,
                'text': 'Latitude',
                'validator': doubleValidator
              },
              {
                'controller': etaTextController,
                'text': 'Proximity',
                'validator': doubleValidator
              },
              {
                'controller': phoneNumTextController,
                'text': 'Phone Number',
                'validator': defaultValidator
              },
              {
                'controller': phoneNameTextController,
                'text': 'Phone Number Name',
                'validator': defaultValidator
              }
            ]),
          ),
        ),
      ),
    );
  }

  void sendForm() async {
    ProximityReminder proximityReminder = ProximityReminder(
      longitude: double.parse(longTextController.text),
      latitude: double.parse(latTextController.text),
      proximity: double.parse(etaTextController.text),
      phoneNumber: phoneNumTextController.text,
      phoneNumberName: phoneNameTextController.text,
    );

    await AppDatabase.instance.createProximityReminder(proximityReminder);
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
        child: TextFormField(
          controller: inputField['controller'],
          validator: inputField['validator'],
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Please Input the ${inputField['text']}',
          ),
        ),
      ));
    }

    listOfTextFields.add(ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            sendForm();

            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.add)));

    return listOfTextFields;
  }

  String? doubleValidator(value) {
    if (value == null || value.isEmpty || double.tryParse(value) == null) {
      return 'Please enter a number';
    }
    return null;
  }

  String? defaultValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    return null;
  }
}
