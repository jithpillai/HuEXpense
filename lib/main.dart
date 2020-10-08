import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hueganizer/constants/constants.dart';
import 'package:hueganizer/widgets/huelist/huelist_route.dart';
import 'package:hueganizer/widgets/huenotes/huenotes_route.dart';
import 'package:hueganizer/widgets/huestore/huestore_route.dart';
import 'package:hueganizer/widgets/huexpense/huexpense_route.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String landingPage = '/store';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hueganizer',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: landingPage, 
      routes: { 
        '/': (context) => HueXpenseRoute(), 
        HueConstants.hueXpense: (context) => HueXpenseRoute(), 
        HueConstants.hueNotes: (context) => HueNotesRoute(), 
        HueConstants.hueList: (context) => HueListRoute(), 
        HueConstants.hueStore: (context) => HueStoreRoute(), 
      },
    );
  }
}

