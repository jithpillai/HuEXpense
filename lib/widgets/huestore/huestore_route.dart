import 'package:flutter/material.dart';
import 'package:hueganizer/widgets/app_drawer.dart';

class HueStoreRoute extends StatefulWidget {

  static const String routeName = '/store';
  @override
  _HueStoreRouteState createState() => _HueStoreRouteState();
}

class _HueStoreRouteState extends State<HueStoreRoute> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Hue-Store"),
        ),
        drawer: AppDrawer(),
        body: Center(
          child: Container(
              height: 250,
              child: Image.asset(
                'assets/images/comingSoon.jpg',
                fit: BoxFit.cover,
              ),
            ),
        ));
  }
}
