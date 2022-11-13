import 'dart:convert';
import 'package:http/http.dart' as http;

String apiUrl = 'localhost.localhost:3000';

void findDistanceFromAPI(double myLon, double myLat, double timeThresh,
    double lon, double lat) async {
  String endpoint = '/checkdistance';

  var response = await http.Client().get(Uri.parse(
      '$apiUrl$endpoint?my_lon=$myLon&my_lat=$myLat&time_thresh=$timeThresh&lon=$lon&lat=&lat'));

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
  } else {
    throw Exception('Response code was not 200, was ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> getLonLatFromAddress(String address) async {
  String endpoint = '/getcoordinates';

  var response =
      await http.Client().get(Uri.parse('$apiUrl$endpoint?address=$address'));

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    return json;
  } else {
    throw Exception('Response code was not 200, was ${response.statusCode}');
  }
}
