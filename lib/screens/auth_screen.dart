import 'package:flutter/material.dart';
import 'package:richard_parker/constants/screen_size.dart';
import 'package:richard_parker/utils/https.dart';
import 'package:richard_parker/widgets/auth_fade_stack.dart';
import 'package:richard_parker/widgets/auth_input_check_num.dart';
import 'package:richard_parker/widgets/auth_input_email.dart';
import 'package:richard_parker/widgets/auth_register.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // 0: 이메일 입력, 1: checkNum 입력, 2: 회원가입
  int _authScreenIndex = 0;

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _registerEmailController = TextEditingController();
  TextEditingController _checkNumController = TextEditingController();
  TextEditingController _nickController = TextEditingController();

  final Map<int, String> _bottomButtonLeftString = {
    0: '아직 계정이 없으신가요?  ',
    1: '다른 계정으로 로그인하기',
    2: '계정이 있으신가요?  '
  };
  final Map<int, String> _bottomButtonRightString = {
    0: '회원가입',
    1: '',
    2: '로그인'
  };

  final Map<String, String> _snackBarText = {
    'no account': '없는 계정입니다!',
    'send mail': '전송된 인증번호를 확인해주세요!',
    'retry': '5번 틀리셨습니다. 다시 인증요청해주세요!',
    'expired': '인증요청 후 3분이 지났습니다!',
    'not equal': '인증번호가 일치하지 않습니다!',
    'err': '네트워크를 확인해주세요!',
    'same email': '동일한 이메일로 가입이 되어있습니다!',
    'same nick': '동일한 닉네임이 이미 있습니다!',
    'done': '회원가입이 완료되었습니다. 로그인해주세요!',
  };

  List<Widget> _authScreens;

  @override
  void initState() {
    super.initState();
    _authScreens = [
      AuthInputEmail(
          requestCheckNum: _requestCheckNum, emailController: _emailController),
      AuthInputCheckNum(
        submitCheckNum: _submitCheckNum,
        requestResendCheckNum: _requestResendCheckNum,
        checkNumController: _checkNumController,
      ),
      AuthRegister(
        requestRegister: _requestRegister,
        emailController: _registerEmailController,
        nickController: _nickController,
      ),
    ];
  }

  @override
  void dispose() {
    _emailController.dispose();
    _registerEmailController.dispose();
    _checkNumController.dispose();
    _nickController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (size == null) size = MediaQuery.of(context).size;
    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            AuthFadeStack(
                authScreenIndex: _authScreenIndex, authScreens: _authScreens),
            _bottomButton(),
          ],
        ),
      ),
    );
  }

  Positioned _bottomButton() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(width: 1, color: Colors.grey),
          ),
        ),
        child: TextButton(
          onPressed: () {
            setState(() {
              // 이메일 입력(0) -> 회원가입(2)
              // 인증번호(1), 회원가입(2) -> 이메일 입력(0)
              _authScreenIndex = _authScreenIndex != 0 ? 0 : 2;
            });
          },
          child: Text.rich(
            TextSpan(
              text: _bottomButtonLeftString[_authScreenIndex],
              style: TextStyle(color: Colors.grey, fontSize: 16),
              children: <TextSpan>[
                TextSpan(
                  text: _bottomButtonRightString[_authScreenIndex],
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String msg) {
    SnackBar snackBar = SnackBar(
      content: Text(_snackBarText[msg]),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          _key.currentState.hideCurrentSnackBar();
        },
      ),
    );
    _key.currentState.hideCurrentSnackBar();
    _key.currentState.showSnackBar(snackBar);
  }

  Future<void> _requestCheckNum() async {
    final msg = await Https.login(_emailController.text);
    print(msg);
    if (msg == "send mail") {
      setState(() {
        _authScreenIndex = 1;
      });
    } else if (msg == 'no account') {
      _registerEmailController.text = _emailController.text;
    }
    _showSnackBar(msg);
  }

  Future<void> _submitCheckNum() async {
    int _checkNum = int.parse(_checkNumController.text);
    final msg = await Https.login(_emailController.text, _checkNum);
    if (msg == "done") {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    } else {
      if (msg == 'retry' || msg == 'expired')
        setState(() {
          _authScreenIndex = 0;
        });
      _showSnackBar(msg);
    }
  }

  Future<void> _requestResendCheckNum() async {
    final msg = await Https.login(_emailController.text, 0, 'resend');
    _showSnackBar(msg);
  }

  Future<void> _requestRegister() async {
    final msg = await Https.register(
        _registerEmailController.text, _nickController.text);
    if (msg == 'done') {
      setState(() {
        _emailController.text = _registerEmailController.text;
        _authScreenIndex = 0;
        _registerEmailController.text = '';
        _nickController.text = '';
      });
    }
    _showSnackBar(msg);
  }
}
