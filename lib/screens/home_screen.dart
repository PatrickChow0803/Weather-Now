import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/location.dart';
import '../utility.dart';

class MyHomePage extends StatelessWidget {
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
        // This Scaffold causes a fade out effect
        const HomeForeground(),
      ],
    );
  }
}

class HomeForeground extends StatelessWidget {
  const HomeForeground({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // used to give color and shape to the Text Field
    const outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.all(
        Radius.circular(30),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
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
                const TextField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search, color: Colors.white),
                    hintText: 'Search City',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    fillColor: Colors.white,
                    border: outlineInputBorder,
                    enabledBorder: outlineInputBorder,
                    focusedBorder: outlineInputBorder,
                  ),
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
                    for (Location location in locations)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            ColorFiltered(
                              colorFilter: const ColorFilter.mode(Colors.black45, BlendMode.darken),
                              child: Image.network(
                                location.imageUrl,
                                height: getHeight(context) * 0.35,
                                width: getWidth(context) * 0.425,
                                fit: BoxFit.cover,
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
                                Text(location.time.toString()),
                                const SizedBox(height: 40),
                                Text(
                                  '${location.temperature}°',
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
                      )
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
  Location(
      text: 'New York',
      time: 1044,
      temperature: 15,
      weather: 'Cloudy',
      imageUrl: 'https://i.ibb.co/df35Y8Q/2.png'),
  Location(
      text: 'San Francisco',
      time: 744,
      temperature: 6,
      weather: 'Raining',
      imageUrl: 'https://i.ibb.co/7WyTr6q/3.png'),
];
