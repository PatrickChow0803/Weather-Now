import 'package:flutter/cupertino.dart';
import 'package:weather_icons/weather_icons.dart';

class LocationModel {
  final String text;
  final double temperature;
  final String weather;
  final String imageUrl;
  final int timezone;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final double humidity;

  LocationModel({
    this.text,
    this.timezone,
    this.temperature,
    this.weather,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.humidity,
    this.imageUrl,
  });

  // factory is used to instantiate an instance of the class
  factory LocationModel.fromJson(dynamic json) {
    // Use this in postman for reference
    // https://api.openweathermap.org/data/2.5/weather?zip=11229,us&appid=
    return LocationModel(
      text: json['name'] as String,
      // getting the current time from the API doesn't work since the value isn't updated every second.
      // therefore the actual time to display is calculated by getting the DateTime.now().millisecondsSinceEpoch + timezone
      timezone: json['timezone'] as int,
      temperature: json['main']['temp'] as double,
      weather: json['weather'][0]['main'] as String,
      feelsLike: json['main']['feels_like'] as double,
      tempMin: json['main']['temp_min'] as double,
      tempMax: json['main']['temp_max'] as double,
      humidity: json['main']['temp_max'] as double,
      imageUrl: 'https://i.ibb.co/df35Y8Q/2.png',
    );
  }
}
