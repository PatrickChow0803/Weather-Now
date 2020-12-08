import 'package:flutter/material.dart';

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
            color: Color(0xFF2D2C35),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.black54,
        )
      ],
    );
  }
}
