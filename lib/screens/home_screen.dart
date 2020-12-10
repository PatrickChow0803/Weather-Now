import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:weather_app/services/geo_location.dart';
import 'package:weather_app/services/weather.dart';
import 'package:weather_app/widgets/weather_card.dart';

import '../models/location.dart';
import '../utility.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _weather = Weather();
  final _location = GeoLocation();
  bool _loadingApp = false;
  LocationModel _currentLocationWeather;

  @override
  void initState() {
    super.initState();
    _loadingApp = !_loadingApp;

    // After getting the coordinates, use them to get the weather
    _location.getCurrentLocation().then((value) =>
        _weather.getWeatherByCoordinates(_location.latitude, _location.longitude).then((value) {
          _currentLocationWeather = value;
          changeLoading();
        }));
  }

  void changeLoading() {
    setState(() {
      _loadingApp = !_loadingApp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loadingApp
        ? const SpinKitFadingCircle(
            color: Colors.white,
            size: 150,
          )
        : Stack(
            children: [
              Positioned(
                bottom: getHeight(context) / 2.4,
                child: FadeInImage.memoryNetwork(
                  image:
                      'https://www.tripsavvy.com/thmb/BpHEq6bT8Y4xvbcpYsrGJi8LSFo=/2119x1414/filters:fill(auto,1)/42nd-street-at-night-5c397abc4cedfd0001f90bad.jpg',
                  height: getHeight(context),
                  width: getWidth(context),
                  fit: BoxFit.cover,
                  placeholder: kTransparentImage,
                  fadeInDuration: const Duration(seconds: 2),
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
              // This Scaffold causes a fade out effect
              HomeForeground(_weather, _location, _currentLocationWeather),
            ],
          );
  }
}

class HomeForeground extends StatefulWidget {
  final Weather _weather;
  final GeoLocation _location;
  final LocationModel _currentLocationWeather;

  const HomeForeground(this._weather, this._location, this._currentLocationWeather, {Key key})
      : super(key: key);

  @override
  _HomeForegroundState createState() => _HomeForegroundState();
}

class _HomeForegroundState extends State<HomeForeground> {
  final _searchController = TextEditingController();
  bool _searchByCity = true;

  @override
  Widget build(BuildContext context) {
    // used to give color and shape to the Text Field
    const outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.all(
        Radius.circular(30),
      ),
    );

    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            widget._weather
                .getWeatherByCoordinates(widget._location.latitude, widget._location.longitude);
          },
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(
                'https://lh3.googleusercontent.com/a-/AOh14GhLpl-fIkDipAjfHrC7zcifmUuxmu1T1U9zO2Hdeg=s88-c-k-c0x00ffffff-no-rj-mo',
              ),
            ),
            onPressed: () {
              print('called');
            },
          )
        ],
      ),
      // prevents overflow from soft keyboard
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          // DefaultTextStyle makes it so that all the widgets within it use the same style
          child: DefaultTextStyle(
            style: GoogleFonts.raleway(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Hello Patrick',
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Check the weather by the city',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 35),
                TextField(
                  controller: _searchController,
                  style: textStyle,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchByCity = !_searchByCity;
                        });
                      },
                      splashRadius: 20,
                      icon: const Icon(
                        Icons.swap_horiz,
                        color: Colors.white,
                      ),
                    ),
                    suffixIcon: IconButton(
                        splashRadius: 20,
                        onPressed: () async {
                          if (_searchByCity) {
                            await widget._weather.getWeatherByCity(_searchController.text);
                          } else {
                            await widget._weather.getWeatherByZipCode(_searchController.text);
                          }
                        },
                        icon: const Icon(Icons.search, color: Colors.white)),
                    hintText: _searchByCity ? 'Search By City Name' : 'Search By Zip',
                    hintStyle: textStyle,
                    fillColor: Colors.white,
                    border: outlineInputBorder,
                    enabledBorder: outlineInputBorder,
                    focusedBorder: outlineInputBorder,
                  ),
                  onSubmitted: (value) async {
                    if (_searchByCity) {
                      await widget._weather.getWeatherByCity(value);
                    } else {
                      await widget._weather.getWeatherByZipCode(value);
                    }
                  },
                ),
                const SizedBox(height: 90),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Locations',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                          primary: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          shape: const CircleBorder()),
                      child: const Icon(Icons.more_horiz),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (LocationModel location in locations)
                      WeatherCard(location: widget._currentLocationWeather)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final locations = [
  LocationModel(
      text: 'New York',
      // time: 1044,
      temperature: 15,
      weather: 'Cloudy',
      imageUrl: 'https://i.ibb.co/df35Y8Q/2.png'),
  LocationModel(
      text: 'San Francisco',
      // time: 744,
      temperature: 6,
      weather: 'Raining',
      imageUrl: 'https://i.ibb.co/7WyTr6q/3.png'),
];
