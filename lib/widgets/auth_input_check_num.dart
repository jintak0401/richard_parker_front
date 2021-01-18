import 'package:flutter/material.dart';
import 'package:richard_parker/constants/common_size.dart';
import 'package:richard_parker/constants/screen_size.dart';
import 'package:richard_parker/constants/text_input_deco.dart';
import 'package:richard_parker/widgets/auth_logo.dart';

class AuthInputCheckNum extends StatefulWidget {
  final Function submitCheckNum;
  final Function requestResendCheckNum;
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
              AuthLogo(),
              SizedBox(height: size.width / 5),
              _checkNumInputBox(),
              SizedBox(height: common_l_gap),
              _resendButton(),
              SizedBox(height: common_l_gap),
              _loginButton(),
            ],
          ),
        ),
      ),
    );
  }

  TextButton _loginButton() {
    return TextButton(
      onPressed: () {
        _focusNode.unfocus();
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

  Align _resendButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          _focusNode.unfocus();
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

  TextFormField _checkNumInputBox() {
    return TextFormField(
      controller: widget.checkNumController,
      keyboardType: TextInputType.number,
      decoration: textInputDeco('인증번호'),
      focusNode: _focusNode,
      validator: (String text) {
        if (text.length == 5 && (int.tryParse(text) ?? -1) > 0) {
          return null;
        } else {
          return '6자리 숫자가 아닙니다';
        }
      },
    );
  }
}
