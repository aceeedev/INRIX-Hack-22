import 'package:flutter/material.dart';
import 'package:inrix_hack_22/models/proximity_reminder.dart';
import 'package:inrix_hack_22/backend/database_manager.dart';
import 'package:inrix_hack_22/backend/flask_api.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final addressTextController = TextEditingController();
  final etaTextController = TextEditingController();
  final phoneNumTextController = TextEditingController();
  final phoneNameTextController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // dispose of text controllers
    addressTextController.dispose();
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
          child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: createTextForms([
              {
                'controller': addressTextController,
                'text': 'Address',
                'validator': defaultValidator
              },
              {
                'controller': etaTextController,
                'text': 'Warning Threshold (minutes)',
                'validator': intValidator
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
      )),
    );
  }

  Future<void> sendForm() async {
    // first find long and lat from address
    Map<String, dynamic> lonLat =
        await getLonLatFromAddress(addressTextController.text);

    ProximityReminder proximityReminder = ProximityReminder(
      longitude: lonLat['lon'] as double,
      latitude: lonLat['lat'] as double,
      proximity: int.parse(etaTextController.text),
      address: addressTextController.text,
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
        textAlign: TextAlign.center,
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
            hintText: '${inputField['text']}',
          ),
        ),
      ));
    }

    listOfTextFields.add(ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            await sendForm();

            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.add)));

    return listOfTextFields;
  }

  String? intValidator(value) {
    if (value == null ||
        value.isEmpty ||
        int.tryParse(value) == null ||
        int.parse(value) < 1 ||
        int.parse(value) > 90) {
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
