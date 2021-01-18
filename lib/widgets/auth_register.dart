import 'package:flutter/material.dart';
import 'package:richard_parker/constants/common_size.dart';
import 'package:richard_parker/constants/screen_size.dart';
import 'package:richard_parker/constants/text_input_deco.dart';
import 'package:richard_parker/widgets/auth_logo.dart';

class AuthRegister extends StatefulWidget {
  // 회원가입 버튼 눌렀을 때 호출
  final Function requestRegister;
  // 이메일 입력 박스 controller
  final TextEditingController emailController;
  // 닉네임 입력 박스 controller
  final TextEditingController nickController;

  const AuthRegister(
      {Key key,
      this.requestRegister,
      this.emailController,
      this.nickController})
      : super(key: key);

  @override
  _AuthRegisterState createState() => _AuthRegisterState();
}

class _AuthRegisterState extends State<AuthRegister> {
  // 입력 서식 확인용 key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _nickFocusNode = FocusNode();

  @override
  void dispose() {
    // 이메일 입력 박스 focus 여부를 다루기 위한 FocusNode
    _emailFocusNode.dispose();
    // 닉네임 입력 박스 focus 여부를 다루기 위한 FocusNode
    _nickFocusNode.dispose();
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
              // 닉네임 입력 박스
              _nickInputBox(),
              SizedBox(height: common_l_gap),
              // 회원가입 버튼
              _registerButton(),
            ],
          ),
        ),
      ),
    );
  }

  // 회원가입 버튼
  TextButton _registerButton() {
    return TextButton(
      // 눌렀을 때
      onPressed: () {
        // 이메일 & 닉네임 입력박스 focus 해제
        _emailFocusNode.unfocus();
        _nickFocusNode.unfocus();
        // 입력 서식이 올바를 경우
        // AuthScreen 의 _requestRegister() 호출
        if (_formKey.currentState.validate()) {
          widget.requestRegister();
        }
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.blueAccent,
      ),
      child: Text(
        '회원가입',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  // 닉네입 입력 박스
  TextFormField _nickInputBox() {
    return TextFormField(
      controller: widget.nickController,
      decoration: textInputDeco('닉네임'),
      focusNode: _nickFocusNode,
      validator: (String text) {
        // 1 <= 닉네임 길이 <= 9 인지 확인
        if (0 < text.length && text.length < 10) {
          return null;
        } else {
          return '1자 이상 9자 이하의 닉네임을 입력해주세요';
        }
      },
    );
  }

  // 이메일 입력 박스
  TextFormField _emailInputBox() {
    return TextFormField(
      controller: widget.emailController,
      decoration: textInputDeco('이메일'),
      focusNode: _emailFocusNode,
      validator: (String text) {
        // 일단 '@' 글자 포함 여부만 확인
        if (text.contains('@')) {
          return null;
        } else {
          return '잘못된 이메일 형식입니다';
        }
      },
    );
  }
}
