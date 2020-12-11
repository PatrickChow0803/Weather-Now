import 'dart:async';

import 'package:geolocator/geolocator.dart';

class GeoLocation {
  bool _serviceEnabled;
  // LocationPermission _permission;
  double _latitude = 0;
  double _longitude = 0;

  double get latitude => _latitude;
  double get longitude => _longitude;

  Future<void> getCurrentLocation() async {
    try {
      if (!await Geolocator().isLocationServiceEnabled()) {
        return Future.error('Location Service not enabled');
      }

      final Position position =
          await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

      // print(position);
      _latitude = position.latitude;
      _longitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }
}
