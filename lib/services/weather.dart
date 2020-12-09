import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Weather {
  final String _apiKey = DotEnv().env['WEATHER_API'];
  final String urlByCity = 'https://api.openweathermap.org/data/2.5/weather?q=';
  final String urlByCoordinates = '';

  Future<void> getWeatherByCity(String city) async {
    try {
      final response = await http.get('$urlByCity$city&appid=$_apiKey');
      print(response.statusCode);
      print(response.body);
    } catch (e) {
      print('getWeatherByCity Error:$e');
    }
  }

  Future<void> getWeatherByCoordinates(double latitude, double longitude) async {
    try {
      final response = await http.get(
          'https://api.openweathermap.org/data/2.5/weather?lat=${latitude}&lon=${longitude}&appid=$_apiKey');
      print(response.body);
    } catch (e) {
      print('PORQUE:$e');
    }
  }
}
