import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/location.dart';

class Weather {
  final String _apiKey = DotEnv().env['WEATHER_API'];

  Future<LocationModel> getWeatherByCity(String city) async {
    try {
      // https://api.openweathermap.org/data/2.5/forecast?q={city name}&appid={API key}
      final response = await http.get(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&units=imperial&appid=$_apiKey');
      print(response.body);
      final decodedJson = jsonDecode(response.body);
      return LocationModel.fromJson(decodedJson);
    } on HttpException catch (e) {
      // do ...
      return LocationModel();
    } catch (e) {
      print('getWeatherByCity Error: $e');
      return LocationModel();
    }
  }

  Future<LocationModel> getWeatherByCoordinates(double latitude, double longitude) async {
    try {
      // https://api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API key}
      final response = await http.get(
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=imperial&appid=$_apiKey');
      print(response.body);
      final decodedJson = jsonDecode(response.body);

      return LocationModel.fromJson(decodedJson);
    } catch (e) {
      print('getWeatherByCoordinates Error: $e');
      return LocationModel();
    }
  }

  Future<LocationModel> getWeatherByZipCode(String zipCode) async {
    try {
      // https://api.openweathermap.org/data/2.5/forecast?zip={zip code},{country code}&appid={API key}
      final response = await http.get(
          'https://api.openweathermap.org/data/2.5/weather?zip=$zipCode&units=imperial&appid=$_apiKey');

      print(response.body);
      final decodedJson = jsonDecode(response.body);
      return LocationModel.fromJson(decodedJson);
    } catch (e) {
      print('getWeatherByZipCode Error: $e');
      return LocationModel();
    }
  }
}
