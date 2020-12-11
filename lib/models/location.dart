import 'package:flutter/cupertino.dart';
import 'package:weather_icons/weather_icons.dart';

class LocationModel {
  final String name;
  final double temperature;
  final String weather;
  final String imageUrl;
  final int timezone;
  final double feelsLike;
  final int tempMin;
  final double tempMax;
  final double humidity;
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
  factory LocationModel.fromJson(dynamic json) {
    // Use this in postman for reference
    // https://api.openweathermap.org/data/2.5/weather?zip=11229,us&appid=
    return LocationModel(
      name: json['name'] as String,
      // getting the current time from the API doesn't work since the value isn't updated every second.
      // therefore the actual time to display is calculated by getting the DateTime.now().millisecondsSinceEpoch + timezone
      timezone: json['timezone'] as int,
      temperature: json['main']['temp'] as double,
      weather: json['weather'][0]['main'] as String,
      feelsLike: json['main']['feels_like'] as double,
      // for some reason this is an int instead of a double
      tempMin: json['main']['temp_min'] as int,
      tempMax: json['main']['temp_max'] as double,
      humidity: json['main']['temp_max'] as double,
      wind: json['wind']['speed'] as double,
      imageUrl: 'https://i.ibb.co/df35Y8Q/2.png',
    );
  }
}
