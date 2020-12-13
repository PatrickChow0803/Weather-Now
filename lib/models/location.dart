import 'package:flutter/cupertino.dart';
import 'package:weather_icons/weather_icons.dart';

class LocationModel {
  // For some reason the API sometimes returns an int, sometimes a double
  // Therefore some of the number related variables are as type dynamic
  final String name;
  final dynamic temperature;
  final String weather;
  final String imageUrl;
  final int timezone;
  final dynamic feelsLike;
  final dynamic tempMin;
  final dynamic tempMax;
  final dynamic humidity;
  final double wind;

  LocationModel({
    this.name,
    this.timezone,
    this.temperature,
    this.weather,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.humidity,
    this.wind,
    this.imageUrl,
  });

  // factory is used to instantiate an instance of the class
  factory LocationModel.fromJson(Map<String, dynamic> jsonMap) {
    // Use this in postman for reference
    // https://api.openweathermap.org/data/2.5/weather?zip=11229,us&appid=
    return LocationModel(
      name: jsonMap['name'] as String,
      // getting the current time from the API doesn't work since the value isn't updated every second.
      // therefore the actual time to display is calculated by getting the DateTime.now().millisecondsSinceEpoch + timezone
      timezone: jsonMap['timezone'] as int,
      temperature: jsonMap['main']['temp'] as dynamic,
      weather: jsonMap['weather'][0]['main'] as String,
      feelsLike: jsonMap['main']['feels_like'] as dynamic,
      // for some reason tempMin is sometimes an Int or Double
      tempMin: jsonMap['main']['temp_min'] as dynamic,
      tempMax: jsonMap['main']['temp_max'] as dynamic,
      humidity: jsonMap['main']['temp_max'] as dynamic,
      wind: jsonMap['wind']['speed'] as double,
      imageUrl: 'https://i.ibb.co/df35Y8Q/2.png',
    );
  }
}
