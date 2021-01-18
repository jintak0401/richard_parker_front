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
      // 앱 구동 후 첫 로딩 화면
      // 로그인시 -> '/home' | 로그인이 안되었을시 -> '/auth'
      home: Splash(),
      routes: <String, WidgetBuilder>{
        // 로그인을 위한 페이지
        '/auth': (BuildContext context) => AuthScreen(),
        // 로그인 이후 메인 페이지
        '/home': (BuildContext context) => HomeScreen(),
      },
    );
  }
}
