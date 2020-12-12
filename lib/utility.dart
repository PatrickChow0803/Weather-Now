import 'package:flutter/material.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/screens/details_screen.dart';

double getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

void goToDetailsScreen(BuildContext context, LocationModel location) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => DetailsScreen(location: location)));
}
