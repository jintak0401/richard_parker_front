import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:richard_parker/utils/auth.dart';
// import 'package:http/http.dart' as http;

class Https {
  static final storage = FlutterSecureStorage();
  static final Https _https = Https._internal();
  static final String _baseUrl = "http://10.0.2.2:8010";
  static String _accessToken = "";

  factory Https() {
    return _https;
  }

  Https._internal() {}

  // refreshToken을 넘겨주면 write, 아무것도 안넘겨주면 delete
  static void _writeRefreshToken([String refreshToken]) {
    if (refreshToken != null)
      storage.write(key: "refreshToken", value: refreshToken);
    else
      storage.delete(key: "refreshToken");
  }

  static Future<String> _readRefreshToken() async {
    return await storage.read(key: "refreshToken");
  }

  static Future<bool> isLogined() async {
    try {
      String refreshToken = await _readRefreshToken();
      Map<String, dynamic> data = await Auth.getNewTokens(refreshToken);
      switch (data['msg']) {
        case 'need login':
          return false;
        case 'done':
          _accessToken = data['accessToken'];
          _writeRefreshToken(data['refreshToken']);
          return true;
        default:
          print('/utils/https.dart (isLogined) => default\n${data['msg']}');
          return false;
      }
    } catch (err) {
      print('/utils/https.dart (isLogined) => err\n$err');
      return false;
    }
  }

  // 없는 계정일 때: 'no account', 메일 전송시: 'send mail', 로그인 됐을 때: 'done', 5번 이상 틀렸을 때: 'retry'
  // 로그인 요청시간 지났을 때: 'expired', 인증번호 불일치 시: 'not equal', 에러시 "err"
  static Future<String> login(String email, [int checkNum, String msg]) async {
    try {
      Map<String, dynamic> data = await Auth.login(email, checkNum, msg);
      if (data['msg'] == 'done') {
        _accessToken = data['accessToken'];
        _writeRefreshToken(data['refreshToken']);
      }
      return data['msg'];
    } catch (err) {
      print('/utils/https.dart (login) => err\n$err');
      return "err";
    }
  }

  static void logout() async {
    try {
      String refreshToken = await _readRefreshToken();
      Auth.logout(refreshToken);
      _writeRefreshToken(); // secure_storage 에서 refresh_token 제거
    } catch (err) {
      print('/utils/https.dart (logout) => err\n$err');
    }
  }

  // 중복 이메일: "same email", 중복 닉네임: "same nick", 성공: "done", 에러: "err"
  static Future<String> register(String email, String nick) {
    return Auth.register(email, nick);
  }
}
