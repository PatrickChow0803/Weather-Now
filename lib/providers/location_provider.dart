import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/models/location.dart';
import 'package:http/http.dart' as http;

class LocationProvider with ChangeNotifier {
  final String _apiKey = DotEnv().env['WEATHER_API'];
  final List<LocationModel> _locations = [
    LocationModel(
        name: 'Test',
        weather: 'Cloudy',
        temperature: 55,
        tempMax: 100,
        tempMin: 5,
        feelsLike: 123,
        humidity: 20,
        timezone: 0,
        wind: 5)
  ];

  List<LocationModel> get locations {
    return [..._locations];
  }

  Future<void> addLocationByCity() async {}

  Future<void> addLocationByCoordinates({double latitude, double longitude}) async {
    try {
      // https://api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API key}
      final response = await http.get(
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=imperial&appid=$_apiKey');
      print(response.body);
      final decodedJson = jsonDecode(response.body) as Map<String, dynamic>;

      final locationTest = LocationModel.fromJson(decodedJson);
      _locations.add(locationTest);
      notifyListeners();
    } catch (e) {
      print('getWeatherByCoordinates Error: $e');
      return LocationModel();
    }
  }

  Future<void> addLocationByZip() async {}
}
