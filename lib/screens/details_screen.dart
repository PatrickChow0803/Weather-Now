import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/services/auth.dart';
import 'package:weather_icons/weather_icons.dart';

import '../utility.dart';

class DetailsScreen extends StatelessWidget {
  final LocationModel location;
  const DetailsScreen({this.location, Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: getHeight(context) / 2.4,
          child: CachedNetworkImage(
            imageUrl:
                'https://www.tripsavvy.com/thmb/BpHEq6bT8Y4xvbcpYsrGJi8LSFo=/2119x1414/filters:fill(auto,1)/42nd-street-at-night-5c397abc4cedfd0001f90bad.jpg',
            height: getHeight(context),
            width: getWidth(context),
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: getWidth(context),
            height: getWidth(context) / 1.3,
            color: const Color(0xFF2D2C35),
          ),
        ),
        DetailForeground(
          location: location,
        )
      ],
    );
  }
}

class DetailForeground extends StatelessWidget {
  final LocationModel location;
  const DetailForeground({
    this.location,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bool _isAnonymous = _authProvider.auth.currentUser.isAnonymous;

    // These are used for getting the proper time and updating it.
    DateTime current = DateTime.now();

    final Stream timer = Stream.periodic(
        const Duration(seconds: 1), (i) => current = current.add(const Duration(seconds: 1)));

    int currentUtcEpoch = (DateTime.now().toUtc().millisecondsSinceEpoch / 1000).round();

    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          if (_authProvider.auth.currentUser.photoURL != null)
            IconButton(
              icon: CircleAvatar(
                radius: 15,
                backgroundImage: CachedNetworkImageProvider(
                  _authProvider.auth.currentUser.photoURL,
                ),
              ),
              onPressed: () {},
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // This is purely used to space out the widgets in the row
                Opacity(
                  opacity: 0,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                        primary: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        shape: const CircleBorder()),
                    child: const Icon(Icons.more_horiz),
                  ),
                ),
                Icon(
                  getIcon(location.weather),
                  color: Colors.white,
                  size: 80,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Location has been added to Saved Locations'),
                      ));
                    },
                    style: OutlinedButton.styleFrom(
                        primary: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        shape: const CircleBorder()),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
            DefaultTextStyle(
              style: GoogleFonts.raleway(),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    location.name,
                    style: const TextStyle(fontSize: 30),
                  ),
                  const SizedBox(height: 10),
                  Text(location.weather, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 10),
                  StreamBuilder(
                    stream: timer,
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      // COULD ADD 'hh:mm:ss' into DateFormat's constructor
                      return Text(
                        DateFormat('hh:mm: a').format(DateTime.fromMillisecondsSinceEpoch(
                            // 1000 milliseconds in one second, so you need to multiply by 1000
                            // Time is calculated by getting the device's current time, and then adding onto the difference in seconds between
                            // the device's time zone with the location's time zone.
                            DateTime.now().millisecondsSinceEpoch +
                                getSecondDifference(location.timezone) * 1000)),
                        style: const TextStyle(fontSize: 24),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${location.temperature.round()}°F',
                    style: const TextStyle(fontSize: 80),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Weather Details',
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        WeatherInformation(
                          weatherData: 'Feels Like',
                          weatherValue: location.feelsLike,
                        ),
                        const SizedBox(height: 10),
                        WeatherInformation(
                          weatherData: 'Minimum Temp',
                          weatherValue: location.tempMin,
                        ),
                        const SizedBox(height: 10),
                        WeatherInformation(
                          weatherData: 'Maximum Temp',
                          weatherValue: location.tempMax,
                        ),
                        const SizedBox(height: 10),
                        WeatherInformation(
                          weatherData: 'Humidity',
                          weatherValue: location.humidity,
                          isHumidity: true,
                        ),
                        const SizedBox(height: 10),
                        WeatherInformation(
                          weatherData: 'Wind',
                          weatherValue: location.wind,
                          isWind: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int getSecondDifference(int otherSeconds) {
    final now = DateTime.now();
    // use timeZoneOffset to see the number of hour difference from utc
    final timeZoneOffset = now.timeZoneOffset;
    // because the value of timeZoneOffSet is "-5:00"...
    // use subString to only get the hours
    final String totalHourIs = timeZoneOffset.toString().substring(1, 2);
    // Convert the String hours to int and multiply it by 3600, which is the number of seconds in an hour
    // Then add onto the seconds from timezone that the API gives
    // print('Difference in Seconds is: ${(int.parse(totalHourIs) * 3600) + otherSeconds}');

    return (int.parse(totalHourIs) * 3600) + otherSeconds;
  }

  // https://openweathermap.org/weather-conditions
  // Converts ['weather']['main'] into an IconData to be displayed
  IconData getIcon(String weather) {
    switch (weather) {
      case 'Thunderstorm':
        return WeatherIcons.thunderstorm;
      case 'Drizzle':
        return WeatherIcons.sprinkle;
      case 'Rain':
        return WeatherIcons.rain;
      case 'Snow':
        return WeatherIcons.snow;
      case 'Atmosphere':
        return WeatherIcons.fog;
      case 'Clear':
        return WeatherIcons.day_sunny;
      case 'Clouds':
        return WeatherIcons.cloud;
      default:
        return WeatherIcons.cloud;
    }
  }
}

class WeatherInformation extends StatelessWidget {
  final String weatherData;
  final dynamic weatherValue;
  final bool isWind;
  final bool isHumidity;
  const WeatherInformation({
    Key key,
    this.weatherData,
    this.weatherValue,
    this.isWind = false,
    this.isHumidity = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String weatherValueFormatted = '';
    if ((!isWind) && (!isHumidity)) {
      weatherValueFormatted = '${weatherValue} °F';
    } else if (!isWind) {
      weatherValueFormatted = '$weatherValue %';
    } else {
      weatherValueFormatted = '${weatherValue} mph';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Opacity(
          opacity: .6,
          child: Text(weatherData),
        ),
        Text(weatherValueFormatted),
      ],
    );
  }
}
