import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:weather_app/models/location.dart';

import '../utility.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({
    Key key,
    @required this.location,
  }) : super(key: key);

  final LocationModel location;

  @override
  Widget build(BuildContext context) {
    DateTime current = DateTime.now();
    Stream timer = Stream.periodic(
        const Duration(seconds: 1), (i) => current = current.add(const Duration(seconds: 1)));

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.black45, BlendMode.darken),
            child: FadeInImage.memoryNetwork(
              image: 'https://i.ibb.co/df35Y8Q/2.png',
              height: getHeight(context) * 0.35,
              width: getWidth(context) * 0.425,
              fit: BoxFit.cover,
              placeholder: kTransparentImage,
              fadeInDuration: const Duration(seconds: 2),
            ),
          ),
          Column(
            children: [
              Text(
                location.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
              ),
              StreamBuilder(
                stream: timer,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return Text(DateFormat('hh:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(
                      current.millisecondsSinceEpoch + location.timezone)));
                },
              ),
              const SizedBox(height: 40),
              Text(
                '${location.temperature.round()}°F',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 40),
              Text(location.weather),
            ],
          )
        ],
      ),
    );
  }
}
