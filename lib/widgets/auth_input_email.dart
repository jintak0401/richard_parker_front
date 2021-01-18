import 'package:flutter/material.dart';
import 'package:richard_parker/constants/common_size.dart';
import 'package:richard_parker/constants/screen_size.dart';
import 'package:richard_parker/constants/text_input_deco.dart';

import 'auth_logo.dart';

class AuthInputEmail extends StatefulWidget {
  final Function requestCheckNum;
  final TextEditingController emailController;

  const AuthInputEmail({Key key, this.requestCheckNum, this.emailController})
      : super(key: key);

  @override
  _AuthInputEmailState createState() => _AuthInputEmailState();
}

class _AuthInputEmailState extends State<AuthInputEmail> {
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
              _emailInputBox(),
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

  TextFormField _emailInputBox() {
    return TextFormField(
      controller: widget.emailController,
      decoration: textInputDeco('이메일'),
      focusNode: _focusNode,
      validator: (String text) {
        if (text.contains('@')) {
          return null;
        } else {
          return '잘못된 이메일 형식입니다';
        }
      },
    );
  }
}
