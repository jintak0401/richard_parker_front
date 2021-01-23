import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:richard_parker/screens/auth_screen.dart';
import 'package:richard_parker/screens/home_screen.dart';
import 'package:richard_parker/screens/photo_screen.dart';
import 'package:richard_parker/screens/splash.dart';

void main() {
  // statusBar 색상 변경
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.blueAccent),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => Splash()),
        GetPage(name: '/auth', page: () => AuthScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/photo', page: () => PhotoScreen()),
      ],
    );
  }
}
