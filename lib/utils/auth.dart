import 'package:dio/dio.dart';

class Auth {
  static final _dio = Dio(
    BaseOptions(
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
      throw err;
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
      throw err;
    }
  }
}
