import 'package:flutter/material.dart';
import 'package:richard_parker/constants/common_size.dart';
import 'package:richard_parker/constants/screen_size.dart';
import 'package:richard_parker/constants/text_input_deco.dart';

import 'auth_logo.dart';

class AuthInputEmail extends StatefulWidget {
  // 로그인 버튼 눌렀을 때 호출
  final Function requestCheckNum;
  // 이메일 입력 박스 controller
  final TextEditingController emailController;

  const AuthInputEmail({Key key, this.requestCheckNum, this.emailController})
      : super(key: key);

  @override
  _AuthInputEmailState createState() => _AuthInputEmailState();
}

class _AuthInputEmailState extends State<AuthInputEmail> {
  // 입력 서식 확인용 key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // 이메일 입력 박스 focus 여부를 다루기 위한 FocusNode
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(common_gap),
          child: ListView(
            children: <Widget>[
              SizedBox(height: size.width / 5),
              // 리차드 파커 로고
              AuthLogo(),
              SizedBox(height: size.width / 5),
              // 이메일 입력 박스
              _emailInputBox(),
              SizedBox(height: common_l_gap),
              // 로그인 버튼
              _loginButton(),
            ],
          ),
        ),
      ),
    );
  }

  // 로그인 버튼
  TextButton _loginButton() {
    return TextButton(
      // 눌렀을 때
      onPressed: () {
        // 이메일 입력 박스 focus 해제
        _focusNode.unfocus();
        // 입력 서식이 올바를 경우
        // AuthScreen 의 _requestCheckNum() 호출
        if (_formKey.currentState.validate()) {
          widget.requestCheckNum();
        }
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.blueAccent,
      ),
      child: Text(
        '로그인',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  // 인증번호 입력 박스
  TextFormField _emailInputBox() {
    return TextFormField(
      controller: widget.emailController,
      decoration: textInputDeco('이메일'),
      focusNode: _focusNode,
      validator: (String text) {
        // 일단 '@' 문자만으로 이메일 서식 확인
        if (text.contains('@')) {
          return null;
        } else {
          return '잘못된 이메일 형식입니다';
        }
      },
    );
  }
}
