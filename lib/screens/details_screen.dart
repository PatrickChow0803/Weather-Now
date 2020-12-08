import 'package:flutter/cupertino.dart';
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
            color: Color(0xFF2D2C35),
          ),
        ),
        DetailForeground()
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
        leading: Icon(Icons.arrow_back, size: 20),
        actions: [
          IconButton(
            icon: CircleAvatar(
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
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: getWidth(context),
              child: Icon(
                Icons.cloud,
                color: Colors.white,
                size: 100,
              ),
            ),
            DefaultTextStyle(
              style: GoogleFonts.raleway(),
              child: Container(
                child: Column(
                  children: [
                    Text(
                      'Los Angeles',
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Cloudy, 7:44 AM',
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(height: 80),
                    Text(
                      '23°',
                      style: TextStyle(fontSize: 100),
                    ),
                    SizedBox(height: 10),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Weather Details',
                                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                              ),
                              // Text(''),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Opacity(
                                child: Text('Cloudy'),
                                opacity: .6,
                              ),
                              Text('98%'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Opacity(
                                child: Text('Precipitation'),
                                opacity: .6,
                              ),
                              Text('0%'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Opacity(
                                child: Text('Humidity'),
                                opacity: .6,
                              ),
                              Text('65%'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Opacity(
                                child: Text('Wind'),
                                opacity: .6,
                              ),
                              Text('5 km/h'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
