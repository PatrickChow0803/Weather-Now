class LocationModel {
  final String text;
  final int time;
  final double temperature;
  final String weather;
  final String imageUrl;

  LocationModel({this.text, this.time, this.temperature, this.weather, this.imageUrl});

  // factory is used to instantiate an instance of the class
  factory LocationModel.fromJson(dynamic json) =>
      // Use this in postman for reference
      // https://api.openweathermap.org/data/2.5/weather?zip=11229,us&appid=
      LocationModel(
        text: json['name'] as String,
        time: json['dt'] as int,
        temperature: json['main']['temp'] as double,
        weather: json['weather'][0]['main'] as String,
        imageUrl: 'https://i.ibb.co/df35Y8Q/2.png',
      );
}
