import 'package:flutter/material.dart';
import 'package:hueganizer/widgets/app_drawer.dart';

class HueListRoute extends StatefulWidget {

  static const String routeName = '/list';
  @override
  _HueListRouteState createState() => _HueListRouteState();
}

class _HueListRouteState extends State<HueListRoute> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Hue-List"),
        ),
        drawer: AppDrawer(),
        body: Center(child: Text("Lists")));
  }
}
