import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utility.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: getHeight(context) / 2.4,
          child: Image.network(
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
        const DetailForeground()
      ],
    );
  }
}

class DetailForeground extends StatelessWidget {
  const DetailForeground({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: const Icon(Icons.arrow_back, size: 20),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(
                'https://lh3.googleusercontent.com/a-/AOh14GhLpl-fIkDipAjfHrC7zcifmUuxmu1T1U9zO2Hdeg=s88-c-k-c0x00ffffff-no-rj-mo',
              ),
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            const Icon(
              Icons.cloud,
              color: Colors.white,
              size: 100,
            ),
            DefaultTextStyle(
              style: GoogleFonts.raleway(),
              child: Column(
                children: [
                  const Text(
                    'Los Angeles',
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Cloudy, 7:44 AM',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 80),
                  const Text(
                    '23°',
                    style: TextStyle(fontSize: 100),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Weather Details',
                              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const WeatherInformation(
                          weatherData: 'Cloudy',
                          weatherValue: 93,
                        ),
                        const SizedBox(height: 10),
                        const WeatherInformation(
                          weatherData: 'Precipitation',
                          weatherValue: 0,
                        ),
                        const SizedBox(height: 10),
                        const WeatherInformation(
                          weatherData: 'Humidity',
                          weatherValue: 65,
                        ),
                        const SizedBox(height: 10),
                        const WeatherInformation(
                          weatherData: 'Wind',
                          weatherValue: 5,
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
}

class WeatherInformation extends StatelessWidget {
  final String weatherData;
  final int weatherValue;
  final bool isWind;
  const WeatherInformation({
    Key key,
    this.weatherData,
    this.weatherValue,
    this.isWind = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String weatherValueFormatted = '';
    if (!isWind) {
      weatherValueFormatted = '$weatherValue%';
    } else {
      weatherValueFormatted = '${weatherValue}km/h';
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
