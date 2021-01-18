import 'package:flutter/material.dart';
import 'package:richard_parker/screens/auth_screen.dart';
import 'package:richard_parker/screens/home_screen.dart';
import 'package:richard_parker/screens/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Splash(),
      routes: <String, WidgetBuilder>{
        '/auth': (BuildContext context) => AuthScreen(),
        '/home': (BuildContext context) => HomeScreen(),
      },
    );
  }
}
