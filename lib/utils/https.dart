import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:richard_parker/utils/auth.dart';

// 서버와의 통신과 관련된 함수를 구현한 class
// 모든 함수를 static 함수로 구현할 예정
class Https {
  // refreshToken 을 저장하는 secureStorage
  static final storage = FlutterSecureStorage();
  // 서버 기본 URL
  static final String _baseUrl = "http://10.0.2.2:8010";
  static String _accessToken = "";

  // refreshToken을 넘겨주면 write, 아무것도 안넘겨주면 delete
  static void _writeRefreshToken([String refreshToken]) {
    if (refreshToken != null)
      storage.write(key: "refreshToken", value: refreshToken);
    else
      storage.delete(key: "refreshToken");
  }

  // secure storage 로부터 refreshToken 을 읽어들임
  static Future<String> _readRefreshToken() async {
    return await storage.read(key: "refreshToken");
  }

  // 앱 구동시 자동 로그인 여부 확인 함수
  static Future<bool> isLogined() async {
    String refreshToken = await _readRefreshToken();
    // 유효하지 않은 refresh_token인 경우 -> { msg: "need login" }
    // 유효한 refresh_token인 경우 -> { msg: "done", refreshToken, accessToken, }
    // 에러일 경우 -> { msg: 'err'}
    Map<String, dynamic> data = await Auth.getNewTokens(refreshToken);
    switch (data['msg']) {
      case 'done':
        Https._accessToken = data['accessToken'];
        _writeRefreshToken(data['refreshToken']);
        return true;
      case 'err':
      case 'need login':
        return false;
    }
  }

  // 없는 계정일 때: 'no account', 메일 전송시: 'send mail', 로그인 됐을 때: 'done', 5번 이상 틀렸을 때: 'retry'
  // 로그인 요청시간 지났을 때: 'expired', 인증번호 불일치 시: 'not equal', 에러시 "err"
  static Future<String> login(String email, {int checkNum, String msg}) async {
    Map<String, dynamic> data = await Auth.login(email, checkNum, msg);
    if (data['msg'] == 'done') {
      _accessToken = data['accessToken'];
      _writeRefreshToken(data['refreshToken']);
    }
    return data['msg'];
  }

  // 로그아웃
  static void logout() async {
    String refreshToken = await _readRefreshToken();
    Auth.logout(refreshToken);
    _writeRefreshToken(); // secure_storage 에서 refresh_token 제거
  }

  // 중복 이메일: "same email", 중복 닉네임: "same nick", 성공: "done", 에러: "err"
  static Future<String> register(String email, String nick) {
    return Auth.register(email, nick);
  }
}
