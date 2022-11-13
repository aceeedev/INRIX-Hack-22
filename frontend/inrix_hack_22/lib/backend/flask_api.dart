import 'dart:convert';
import 'package:http/http.dart' as http;

void sendToAPI() async {
  String apiUrl = 'localhost.localhost:3000/';
  String endpoint = '';

  var response = await http.Client().get(Uri.parse('$apiUrl$endpoint'));

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
  } else {
    throw Exception('Response code was not 200, was ${response.statusCode}');
  }
}
