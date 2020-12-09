import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Weather {
  final String _apiKey = DotEnv().env['WEATHER_API'];
  final String urlByCity = 'https://api.openweathermap.org/data/2.5/weather?q=';

  Future<void> getWeatherByCity(String city) async {
    try {
      final response = await http.get('$urlByCity$city&appid=$_apiKey');
      print(response.statusCode);
      print(response.body);
    } catch (e) {
      print('PORQUE:$e');
    }
  }
}
