import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_splash/flutter_splash.dart';
import 'package:hueganizer/constants/constants.dart';
import 'package:hueganizer/widgets/dashboard/hue-dashboard.dart';
import 'package:hueganizer/widgets/huelist/huelist_route.dart';
import 'package:hueganizer/widgets/huenotes/huenotes_route.dart';
import 'package:hueganizer/widgets/huestore/huestore_route.dart';
import 'package:hueganizer/widgets/huexpense/huexpense_route.dart';
import 'package:hueganizer/widgets/voice_detect/voice_read_route.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new Splash(
        seconds: 4,
        navigateAfterSeconds: new AfterSplash(),
        title: new Text(
          HueConstants.appTitle,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        loadingText: Text(
          HueConstants.appDesc,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        image: new Image.asset(
          'assets/images/H.png',
          height: 125.0,
          width: 125.0,
        ),
        backgroundColor: Colors.black,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.red);
  }
}

class AfterSplash extends StatelessWidget {
  String landingPage = HueConstants.hueDashboard;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hueganizer',
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: landingPage,
      routes: {
        '/': (context) => HueDashboard(),
        HueConstants.hueDashboard: (context) => HueDashboard(),
        HueConstants.hueXpense: (context) => HueXpenseRoute(),
        HueConstants.hueNotes: (context) => HueNotesRoute(),
        HueConstants.hueList: (context) => HueListRoute(),
        HueConstants.hueStore: (context) => HueStoreRoute(),
        HueConstants.hueVoiceRead: (context) => VoiceReadRoute(),
      },
    );
  }
}
