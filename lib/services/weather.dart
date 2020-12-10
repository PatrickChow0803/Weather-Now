import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/location.dart';

class Weather {
  final String _apiKey = DotEnv().env['WEATHER_API'];

  Future<void> getWeatherByCity(String city) async {
    try {
      // api.openweathermap.org/data/2.5/forecast?q={city name}&appid={API key}
      final response = await http.get(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&units=imperial&appid=$_apiKey');
      print(response.statusCode);
      print(response.body);
    } catch (e) {
      print('getWeatherByCity Error:$e');
    }
  }

  Future<LocationModel> getWeatherByCoordinates(double latitude, double longitude) async {
    try {
      // api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API key}
      final response = await http.get(
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=imperial&appid=$_apiKey');
      print(response.body);
      var decodedJson = jsonDecode(response.body);

      LocationModel newLocation = LocationModel.fromJson(decodedJson);
      print(newLocation.text);

      return newLocation;
    } catch (e) {
      print('getWeatherByCoordinates Error: $e');
      return LocationModel();
    }
  }

  Future<void> getWeatherByZipCode(String zipCode) async {
    try {
      // api.openweathermap.org/data/2.5/forecast?zip={zip code},{country code}&appid={API key}
      final response = await http.get(
          'api.openweathermap.org/data/2.5/weather?zip=$zipCode&units=imperial&appid=$_apiKey');

      print(response.body);
    } catch (e) {
      print('getWeatherByZipCode Error: $e');
    }
  }
}
