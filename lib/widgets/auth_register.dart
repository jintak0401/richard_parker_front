import 'package:flutter/material.dart';
import 'package:richard_parker/constants/common_size.dart';
import 'package:richard_parker/constants/screen_size.dart';
import 'package:richard_parker/constants/text_input_deco.dart';
import 'package:richard_parker/widgets/auth_logo.dart';

class AuthRegister extends StatefulWidget {
  final Function requestRegister;
  final TextEditingController emailController;
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
    _emailFocusNode.dispose();
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
              AuthLogo(),
              SizedBox(height: size.width / 5),
              _emailInputBox(),
              SizedBox(height: common_l_gap),
              _nickInputBox(),
              SizedBox(height: common_l_gap),
              _registerButton(),
            ],
          ),
        ),
      ),
    );
  }

  TextButton _registerButton() {
    return TextButton(
      onPressed: () {
        _emailFocusNode.unfocus();
        _nickFocusNode.unfocus();
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

  TextFormField _nickInputBox() {
    return TextFormField(
      controller: widget.nickController,
      decoration: textInputDeco('닉네임'),
      focusNode: _nickFocusNode,
      validator: (String text) {
        if (0 < text.length && text.length < 10) {
          return null;
        } else {
          return '1자 이상 9자 이하의 닉네임을 입력해주세요';
        }
      },
    );
  }

  TextFormField _emailInputBox() {
    return TextFormField(
      controller: widget.emailController,
      decoration: textInputDeco('이메일'),
      focusNode: _emailFocusNode,
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
