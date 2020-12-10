import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Weather {
  final String _apiKey = DotEnv().env['WEATHER_API'];

  Future<void> getWeatherByCity(String city) async {
    try {
      // api.openweathermap.org/data/2.5/forecast?q={city name}&appid={API key}
      final response =
          await http.get('https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$_apiKey');
      print(response.statusCode);
      print(response.body);
    } catch (e) {
      print('getWeatherByCity Error:$e');
    }
  }

  Future<void> getWeatherByCoordinates(double latitude, double longitude) async {
    try {
      // api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API key}
      final response = await http.get(
          'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$_apiKey');
      print(response.body);
    } catch (e) {
      print('getWeatherByCoordinates Error: $e');
    }
  }

  Future<void> getWeatherByZipCode(int zipCode) async {
    try {
      // api.openweathermap.org/data/2.5/forecast?zip={zip code},{country code}&appid={API key}
      final response = await http
          .get('https://api.openweathermap.org/data/2.5/forecast?zip=$zipCode&appid=$_apiKey');
    } catch (e) {
      print('getWeatherByZipCode Error: $e');
    }
  }
}
