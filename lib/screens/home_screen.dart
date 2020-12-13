import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/location_provider.dart';
import 'package:weather_app/services/auth.dart';
import 'package:weather_app/services/geo_location.dart';
import 'package:weather_app/services/weather.dart';
import 'package:weather_app/widgets/weather_card.dart';
import 'package:weather_icons/weather_icons.dart';

import '../models/location.dart';
import '../utility.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key key,
  }) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _weather = Weather();
  final _location = GeoLocation();
  LocationProvider _locationProvider;
  bool _loadingApp = false;

  @override
  void initState() {
    super.initState();

    // Need this if you're going to be using the Provider in initstate
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Both of these lines do the same thing
      _locationProvider = context.read<LocationProvider>();
      // _locationProvider = Provider.of<LocationProvider>(context, listen: false);
    });

    // _loadingApp = !_loadingApp;

    // After getting the coordinates, use them to get the weather
    _location.getCurrentLocation().then((value) => _locationProvider
            .addLocationByCoordinates(latitude: _location.latitude, longitude: _location.longitude)
            .then((value) {
          // changeLoading();
        }));
  }

  // void changeLoading() {
  //   setState(() {
  //     _loadingApp = !_loadingApp;
  //   });
  // }

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
                child: CachedNetworkImage(
                  imageUrl:
                      'https://www.tripsavvy.com/thmb/BpHEq6bT8Y4xvbcpYsrGJi8LSFo=/2119x1414/filters:fill(auto,1)/42nd-street-at-night-5c397abc4cedfd0001f90bad.jpg',
                  height: getHeight(context),
                  width: getWidth(context),
                  fit: BoxFit.cover,
                  // placeholder: (context, url) => const Center(
                  //   child: CircularProgressIndicator(),
                  // ),
                  fadeInDuration: const Duration(seconds: 1),
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
              HomeForeground(_weather, _location),
            ],
          );
  }
}

class HomeForeground extends StatefulWidget {
  final Weather _weather;
  final GeoLocation _location;

  const HomeForeground(this._weather, this._location, {Key key}) : super(key: key);

  @override
  _HomeForegroundState createState() => _HomeForegroundState();
}

class _HomeForegroundState extends State<HomeForeground> {
  final _searchController = TextEditingController();
  bool _searchByCity = true;

  @override
  Widget build(BuildContext context) {
    print(' This was called in build widget');
    final _locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool _isAnonymous = _authProvider.auth.currentUser.isAnonymous;
    String _username = _authProvider.auth.currentUser.displayName;

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
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black12,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                ),
                child: Center(
                    child: Column(
                  children: [
                    const Icon(
                      WeatherIcons.day_sunny,
                      size: 48,
                      color: Colors.yellowAccent,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Weather Now',
                      style: TextStyle(fontSize: 30, color: Colors.white70),
                    )
                  ],
                )),
              ),
              ListTile(
                title: const Text('Settings'),
                trailing: const Icon(Icons.settings),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: const Text('Log Out'),
                trailing: const Icon(Icons.logout),
                onTap: () async {
                  // Update the state of the app.
                  // ...
                  await _authProvider.signOut();
                  await _authProvider.signOut();
                  _locationProvider.removeAllLocations();
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (!_isAnonymous)
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
                if (!_isAnonymous)
                  Text(
                    'Hello $_username',
                    style: const TextStyle(fontSize: 30),
                  ),
                const SizedBox(height: 5),
                const Text(
                  'Check the weather by either the city or zip',
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
                          FocusScope.of(context).unfocus();
                          await searchByCityOrZip(
                            searchByCity: _searchByCity,
                            input: _searchController.text,
                          );
                          _searchController.clear();
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
                    FocusScope.of(context).unfocus();
                    await searchByCityOrZip(
                      searchByCity: _searchByCity,
                      input: _searchController.text,
                    );
                    _searchController.clear();
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
                Container(
                  height: getHeight(context) * .375,
                  width: getWidth(context),
                  child: Consumer<LocationProvider>(
                    builder: (
                      context,
                      locationData,
                      child,
                    ) =>
                        ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: locationData.locations.length,
                      itemBuilder: (context, index) {
                        print(' This was called in consumer widget');
                        print('Length of locations: ${locationData.locations.length}');
                        return Row(
                          children: [
                            WeatherCard(location: locationData.locations[index]),
                            const SizedBox(width: 20),
                          ],
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Take in a bool to check to see if either addLocationByCity or addLocationByZip should be called
  // Pass in the two methods.
  // Future<String> since that's the return type, (String searchInput) since that's the argument needed for the method called
  Future<void> searchByCityOrZip({bool searchByCity, String input}) async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    if (searchByCity) {
      final returnValue = await locationProvider.addLocationByCity(input);
      if (returnValue == 'Success') {
        goToDetailsScreen(context, locationProvider.locations.last);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(returnValue),
        ));
      }
    } else {
      final returnValue = await locationProvider.addLocationByZip(input);
      if (returnValue == 'Success') {
        goToDetailsScreen(context, locationProvider.locations.last);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(returnValue),
        ));
      }
    }
  }
}
