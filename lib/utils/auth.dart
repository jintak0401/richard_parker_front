import 'package:dio/dio.dart';

// auth 와 관련된 함수만 이용가능한 class
// 모든 함수를 static 함수로 구현
// error 는 여기서 catch 하여 { 'msg': 'err' } 등의 형태로 return
class Auth {
  static final _dio = Dio(
    BaseOptions(
      // auth 와 관련한 요청만 다루는 class 이므로, baseUrl 을 다음과 같이 설정
      baseUrl: "http://10.0.2.2:8010/auth",
      connectTimeout: 5000,
      receiveTimeout: 3000,
    ),
  );

  // 유효하지 않은 refresh_token인 경우 -> { msg: "need login" }
  // 유효한 refresh_token인 경우 -> { msg: "done", refreshToken, accessToken, }
  static Future<Map<String, dynamic>> getNewTokens(
      String oldRefreshToken) async {
    final Map<String, dynamic> attachment = {"refreshToken": oldRefreshToken};
    try {
      final response = await _dio.post('/token', data: attachment);
      Map<String, dynamic> body = response.data;
      return body;
    } catch (err) {
      print('/utils/auth.dart(getNewTokens) => $err');
      return {'msg': 'err'};
    }
  }

  static Future<bool> logout(String refreshToken) async {
    try {
      await _dio.post('/logout', data: {'refreshToken': refreshToken});
      return Future<bool>.value(true);
    } catch (err) {
      print('/utils/auth.dart(logout) => $err');
      return Future<bool>.value(false);
    }
  }

  // 상황에 따라 다른 msg가 return
  // 중복 이메일: "same email", 중복 닉네임: "same nick", 성공: "done", 에러: "err"
  static Future<String> register(String email, String nick) async {
    final Map<String, String> attachment = {"email": email, "nick": nick};
    try {
      final response = await _dio.post('/register', data: attachment);
      return response.data['msg'];
    } catch (err) {
      print("/utils/auth.dart(register) => $err");
      return "err";
    }
  }

  // 없는 계정일 때: 'no account', 메일 전송시: 'send mail', 로그인 됐을 때: 'done', 5번 이상 틀렸을 때: 'retry'
  // 로그인 요청시간 지났을 때: 'expired', 인증번호 불일치 시: 'not equal', 에러시 "err"
  static Future<Map<String, dynamic>> login(String email,
      [int checkNum, String msg]) async {
    final Map<String, dynamic> attachment = {
      "email": email,
      "checkNum": checkNum,
      "msg": msg
    };
    try {
      final response = await _dio.post('/login', data: attachment);
      Map<String, dynamic> body = response.data;
      return body;
    } catch (err) {
      print("/utils/auth.dart(login) => $err");
      return {'msg': 'err'};
    }
  }
}
