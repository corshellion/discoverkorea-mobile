import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4),
        () => Navigator.pushReplacementNamed(context, '/login'));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 260.0),
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            FlightImageAsset(),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Discover Korea",
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 15.0,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "#ShowYourKoreanSide",
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 13.0,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                        color: Colors.blueGrey),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FlightImageAsset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('assets/logo.png');
    Image image = Image(image: assetImage, width: 120.0, height: 120.0);

    return Container(child: image);
  }
}
