import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  TextEditingController longTextController = TextEditingController();
  TextEditingController latTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController etaTextController = TextEditingController();

  @override
  void dispose() {
    // dispose of text controllers
    longTextController.dispose();
    latTextController.dispose();
    etaTextController.dispose();

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
            {'controller': phoneTextController, 'text': 'Phone Number'}
          ]),
        ),
      ),
    );
  }

  void sendForm() {
    // example of getting text from long: longTextController.text
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
