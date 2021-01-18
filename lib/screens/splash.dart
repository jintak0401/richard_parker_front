import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:richard_parker/constants/common_size.dart';
import 'package:richard_parker/constants/screen_size.dart';
import 'package:richard_parker/utils/https.dart';
import 'package:richard_parker/widgets/auth_logo.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future<bool> _isLogined;

  // 맨 처음 위젯을 빌드할 때 실행
  @override
  void initState() {
    super.initState();
    // 로그인이 되었는지 확인
    // 로그인이 되어있을 때 -> '/home', 로그인이 안되었을 때 -> '/auth'
    _isLogined = Https.isLogined();
    _isLogined.then((value) =>
        Navigator.of(context).pushReplacementNamed(value ? '/home' : '/auth'));
  }

  @override
  Widget build(BuildContext context) {
    // 디바이스의 사이즈를 저장
    if (size == null) size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AuthLogo(),
            SizedBox(height: common_l_gap),
            Text(
              '로딩 중',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
