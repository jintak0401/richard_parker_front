import 'package:flutter/material.dart';
import 'package:richard_parker/constants/common_size.dart';
import 'package:richard_parker/constants/screen_size.dart';
import 'package:richard_parker/constants/text_input_deco.dart';
import 'package:richard_parker/widgets/auth_logo.dart';

class AuthInputCheckNum extends StatefulWidget {
  // 로그인 버튼 눌렀을 때 호출
  final Function submitCheckNum;
  // 재전송 버튼 눌렀을 때 호출
  final Function requestResendCheckNum;
  // 인증번호 입력 박스 controller
  final TextEditingController checkNumController;

  const AuthInputCheckNum(
      {Key key,
      this.submitCheckNum,
      this.requestResendCheckNum,
      this.checkNumController})
      : super(key: key);
  @override
  _AuthInputCheckNumState createState() => _AuthInputCheckNumState();
}

class _AuthInputCheckNumState extends State<AuthInputCheckNum> {
  // 입력 서식 확인용 key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // 인증번호 입력 박스 focus 여부를 다루기 위한 FocusNode
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
      // 입력 서식 확인을 위한 Form 위젯
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
              // 인증번호 입력 박스
              _checkNumInputBox(),
              SizedBox(height: common_l_gap),
              // 재전송 버튼
              _resendButton(),
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
      onPressed: () {
        // 버튼을 눌렀을 때, 입력상자의 focus를 해제
        _focusNode.unfocus();
        // 입력 서식이 올바를 경우
        // AuthScreen 의 _submitCheckNum() 호출
        if (_formKey.currentState.validate()) {
          widget.submitCheckNum();
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

  // 재전송 버튼
  Align _resendButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // 버튼을 눌렀을 때, 입력상자의 focus를 해제
          _focusNode.unfocus();
          // AuthScreen 의 _requestResendCheckNum() 호출
          widget.requestResendCheckNum();
        },
        child: Text(
          '인증번호 재전송',
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  // 인증번호 입력 박스
  TextFormField _checkNumInputBox() {
    return TextFormField(
      controller: widget.checkNumController,
      keyboardType: TextInputType.number,
      decoration: textInputDeco('인증번호'),
      focusNode: _focusNode,
      validator: (String text) {
        // 5자리인지 확인, 5자리 정수인지 확인
        if (text.length == 5 && (int.tryParse(text) ?? -1) > 0) {
          return null;
        } else {
          // 올바른 인증번호 서식이 아닐 경우 error 메시지
          return '6자리 숫자가 아닙니다';
        }
      },
    );
  }
}
