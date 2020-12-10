class LocationModel {
  final String text;
  final int time;
  final double temperature;
  final String weather;
  final String imageUrl;
  final int timezone;

  LocationModel(
      {this.text, this.time, this.timezone, this.temperature, this.weather, this.imageUrl});

  // factory is used to instantiate an instance of the class
  factory LocationModel.fromJson(dynamic json) {
    int time = DateTime.now().millisecondsSinceEpoch;
    // Use this in postman for reference
    // https://api.openweathermap.org/data/2.5/weather?zip=11229,us&appid=
    return LocationModel(
      text: json['name'] as String,
      // getting the current time from the API doesn't work since the value isn't updated every second.
      // therefore the actual time to display is calculated by getting the DateTime.now().millisecondsSinceEpoch + timezone
      time: time,
      timezone: json['timezone'] as int,
      temperature: json['main']['temp'] as double,
      weather: json['weather'][0]['main'] as String,
      imageUrl: 'https://i.ibb.co/df35Y8Q/2.png',
    );
  }
}
