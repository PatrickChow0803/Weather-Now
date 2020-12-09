import 'dart:async';

import 'package:geolocator/geolocator.dart';

class GeoLocation {
  bool _serviceEnabled;
  // LocationPermission _permission;
  double _latitude = 0;
  double _longitude = 0;

  double get latitude => _latitude;
  double get longitude => _longitude;

  Future<void> getPosition() async {
    print('getPosition has been called');
    try {
      // _serviceEnabled = await Geolocator.isLocationServiceEnabled();
      // if (!_serviceEnabled) {
      //   return Future.error('Location services are disabled.');
      // }
      //
      // print('getPosition has been called 1');
      //
      // _permission = await Geolocator.checkPermission();
      // if (_permission == LocationPermission.deniedForever) {
      //   return Future.error(
      //       'Location permissions are permanently denied, we cannot request permissions.');
      // }
      //
      // print('getPosition has been called 2');
      //
      // if (_permission == LocationPermission.denied) {
      //   _permission = await Geolocator.requestPermission();
      //   if (_permission != LocationPermission.whileInUse &&
      //       _permission != LocationPermission.always) {
      //     return Future.error('Location permissions are denied (actual value: $_permission).');
      //   }
      // }

      print('getPosition has been called 3');
      final Position position =
          await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

      print('getPosition has been called 4');
      print(position);
      // _latitude = position.latitude;
      // _longitude = position.longitude;

      // print('getPosition has been called 3');
      // print(_longitude);
      // print(_latitude);
    } catch (e) {
      print('getPosition Error: $e');
    }
  }

  Future<void> getCurrentLocation() async {
    try {
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
