import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/models/location.dart';
import 'package:http/http.dart' as http;

class LocationProvider with ChangeNotifier {
  final String _apiKey = DotEnv().env['WEATHER_API'];
  LocationModel _searchedLocation;
  final List<String> _savedLocations = [];
  final List<LocationModel> _locations = [
    // LocationModel(
    // name: 'Test',
    // weather: 'Cloudy',
    // temperature: 55,
    // tempMax: 100,
    // tempMin: 5,
    // feelsLike: 123,
    // humidity: 20,
    // timezone: 0,
    // wind: 5),
  ];

  List<String> get savedLocations => _savedLocations;

  LocationModel get searchedLocation => _searchedLocation;

  // Only do this syntax when working with a list
  List<LocationModel> get locations {
    return [..._locations];
  }

  Future<String> searchLocationByCity(String city) async {
    try {
      // https://api.openweathermap.org/data/2.5/forecast?q={city name}&appid={API key}
      final response = await http.get(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&units=imperial&appid=$_apiKey');
      // print(response.body);
      final decodedJson = jsonDecode(response.body) as Map<String, dynamic>;
      _searchedLocation = LocationModel.fromJson(decodedJson);
      notifyListeners();
      return 'Success';
    } on http.ClientException catch (e) {
      // do ...
      return 'Invalid City';
    } catch (e) {
      // return 'City Not Found';
      print(e);
      return "Couldn't find City";
    }
  }

  Future<String> searchLocationByCoordinates({double latitude, double longitude}) async {
    try {
      // https://api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API key}
      final response = await http.get(
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=imperial&appid=$_apiKey');
      // print(response.body);
      final decodedJson = jsonDecode(response.body) as Map<String, dynamic>;

      final coordinateLocation = LocationModel.fromJson(decodedJson);
      _locations.add(coordinateLocation);
      notifyListeners();
      return 'Success';
    } catch (e) {
      // print('getWeatherByCoordinates Error: $e');
      rethrow;
    }
  }

  Future<String> searchLocationByZip(String zipCode) async {
    try {
      // https://api.openweathermap.org/data/2.5/forecast?zip={zip code},{country code}&appid={API key}
      final response = await http.get(
          'https://api.openweathermap.org/data/2.5/weather?zip=$zipCode&units=imperial&appid=$_apiKey');
      // print(response.body);
      final decodedJson = jsonDecode(response.body) as Map<String, dynamic>;
      _searchedLocation = LocationModel.fromJson(decodedJson);
      notifyListeners();
      return 'Success';
    } catch (e) {
      // print('getWeatherByZipCode Error: $e');
      return "Couldn't find Zip";
    }
  }

  void addSearchedLocationToLocationList() {
    _locations.insert(1, _searchedLocation);
    notifyListeners();
  }

  Future<void> addLocationToSaved(LocationModel location, String userId) async {
    try {
      if (_locations.contains(location)) {
        return 'Location is already saved to your list';
      }
      // Adds the location locally
      _locations.insert(1, location);

      // Adds the location to FireStore
      await FirebaseFirestore.instance.collection('users').doc(userId).collection('locations').add(
          {'savedLocation': location.name, 'timeAdded': DateTime.now().millisecondsSinceEpoch});

      notifyListeners();
    } on FirebaseException catch (e) {
      return 'FirebaseException: $e';
    } catch (e) {
      rethrow;
    }
  }

  void removeAllLocations() {
    _locations.clear();
    notifyListeners();
  }

  void removeAllSavedLocations() {
    _savedLocations.clear();
    notifyListeners();
  }

  Future<void> getListOfSavedLocations(String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('locations')
        .get()
        .then((value) {
      for (DocumentSnapshot ds in value.docs) {
        _savedLocations.add(ds.get('savedLocation') as String);
      }
    });
  }

  Future<void> removeLocation(String cityName, String userId) async {
    try {
      // Removes the location locally
      _locations.removeWhere((location) => location.name == cityName);

      // CollectionReference locationReference =
      //     FirebaseFirestore.instance.collection('users').doc(userId).collection('locations');

      // Removes the location from firestore
      // Go to the locations collection, then query the collection, getting the QuerySnapshot.
      // Loop though the QuerySnapshot
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('locations')
          .where('savedLocation', isEqualTo: cityName)
          .get()
          .then((snapshot) => {
                for (DocumentSnapshot ds in snapshot.docs)
                  {print(ds.reference), ds.reference.delete()}
              });
      print('Deleted successful');

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
