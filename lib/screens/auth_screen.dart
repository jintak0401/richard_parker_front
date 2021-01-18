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
  // AuthFadeStack(IndexStack) 의 index
  // 0: 이메일 입력, 1: checkNum 입력, 2: 회원가입
  int _authScreenIndex = 0;

  // SnackBar 를 보이게 하기 위한 key
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  // 이메일 입력 페이지의 emailInputBox 컨트롤러
  TextEditingController _emailController = TextEditingController();
  // 인증번호 페이지의 checkNumInputBox 컨트롤러
  TextEditingController _checkNumController = TextEditingController();
  // 회원가입 페이지의 emailInputBox 컨트롤러
  TextEditingController _registerEmailController = TextEditingController();
  // 회원가입 페이지의 nickInputBox 컨트롤러
  TextEditingController _nickController = TextEditingController();

  // 하단 버튼의 왼쪽 텍스트
  final Map<int, String> _bottomButtonLeftString = {
    0: '아직 계정이 없으신가요?  ',
    1: '다른 계정으로 로그인하기',
    2: '계정이 있으신가요?  '
  };
  // 하단 버튼의 오른쪽 텍스트
  final Map<int, String> _bottomButtonRightString = {
    0: '회원가입',
    1: '',
    2: '로그인'
  };

  // SnackBar의 메시지들
  final Map<String, String> _snackBarText = {
    'no account': '없는 계정입니다!',
    'send mail': '전송된 인증번호를 확인해주세요!',
    'retry': '5번 틀리셨습니다. 다시 인증요청해주세요!',
    'expired': '인증요청 후 3분이 지났습니다!',
    'not equal': '인증번호가 일치하지 않습니다!',
    'err': '네트워크를 확인해주세요!',
    'same email': '동일한 이메일로 가입이 되어있습니다!',
    'same nick': '동일한 닉네임이 이미 있습니다!',
    // Https.login() 의 'done'은 바로 '/home' 스크린으로 이동
    // 이 'done'은 Https.register()의 'done'
    'done': '회원가입이 완료되었습니다. 로그인해주세요!',
  };

  // AuthFadeStack(IndexStack)의 페이지
  List<Widget> _authScreens;

  @override
  void initState() {
    super.initState();
    _authScreens = [
      // 0: 이메일 입력 페이지
      // _requestCheckNum: 로그인 버튼 눌렀을 때 호출
      AuthInputEmail(
          requestCheckNum: _requestCheckNum, emailController: _emailController),

      // 1: 인증번호 입력 페이지
      // _submitCheckNum: 로그인 버튼 눌렀을 때 호출
      // _requestResendCheckNum: 재전송 버튼 눌렀을 때 호출
      AuthInputCheckNum(
        submitCheckNum: _submitCheckNum,
        requestResendCheckNum: _requestResendCheckNum,
        checkNumController: _checkNumController,
      ),

      // 2: 회원가입 페이지
      // _requestRegister: 로그인 버튼 눌렀을 때 호출
      AuthRegister(
        requestRegister: _requestRegister,
        emailController: _registerEmailController,
        nickController: _nickController,
      ),
    ];
  }

  // 위젯이 제거될 때 호출
  @override
  void dispose() {
    // 각 controller를 dispose() -> 메모리 해제
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
      // SnackBar를 보여주기 위해 _key 할당
      key: _key,
      // 화면크기가 변동되었을 때, 크기에 맞게 스크린 조절할지 여부(true일 경우 조절, false일 경우 조절 안됨)
      // false로 함으로써 키보드가 올라왔을 때, 하단 버튼이 같이 올라오지 않음
      resizeToAvoidBottomInset: false,
      // SafeArea: StatusBar 를 침범하지 않기 위한 위젯
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // IndexStack 으로 화면간 전환을 자연스럽게 해주기 위해 FadeTransition이 적용되어있음
            AuthFadeStack(
                authScreenIndex: _authScreenIndex, authScreens: _authScreens),
            // 회원가입, 로그인 화면간 전환을 위한 최하단 버튼
            _bottomButton(),
          ],
        ),
      ),
    );
  }

  // 회원가입, 로그인 화면간 전환을 위한 최하단 버튼
  Positioned _bottomButton() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 40,
        // Scaffold의 body와의 구분을 위한 위쪽의 선
        decoration: BoxDecoration(
          color: Colors.white,
          // 위쪽에 선
          border: Border(top: BorderSide(width: 1, color: Colors.grey)),
        ),
        child: TextButton(
          onPressed: () {
            setState(() {
              // 이메일 입력(0) -> 회원가입(2)
              // 인증번호(1), 회원가입(2) -> 이메일 입력(0)
              _authScreenIndex = _authScreenIndex != 0 ? 0 : 2;
            });
          },
          // 한 라인에 여러 스타일의 text를 위한 Text.rich
          child: Text.rich(
            // 왼쪽 텍스트
            TextSpan(
              text: _bottomButtonLeftString[_authScreenIndex],
              style: TextStyle(color: Colors.grey, fontSize: 16),
              children: <TextSpan>[
                // 오른쪽 텍스트
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

  // 각 페이지에서 버튼을 눌렀을 때의 상황에 따라 다른 SnackBar를 보여줌
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
    // 한번에 여러 SnackBar를 띄우지 않기 위해
    // 기존의 SnackBar는 hide
    _key.currentState.hideCurrentSnackBar();
    _key.currentState.showSnackBar(snackBar);
  }

  // 이메일 입력 페이지에서 로그인 버튼을 눌렀을 때 호출
  Future<void> _requestCheckNum() async {
    // 입력받은 이메일로 로그인을 서버로 요청
    final msg = await Https.login(_emailController.text);
    // 가입되어 있는 계정으로 로그인 요청했을 경우
    if (msg == "send mail") {
      setState(() {
        // 인증번호 입력 페이지로 이동
        _authScreenIndex = 1;
      });
    }
    // 없는 계정(회원가입 되지 않은 계정)이었을 경우
    else if (msg == 'no account') {
      _registerEmailController.text = _emailController.text;
    }
    _showSnackBar(msg);
  }

  // 인증번호 입력 페이지에서 로그인 버튼을 눌렀을 때 호출
  Future<void> _submitCheckNum() async {
    int _checkNum = int.parse(_checkNumController.text);
    // 인증번호와 함께 로그인 요청
    final msg = await Https.login(_emailController.text, checkNum: _checkNum);
    // 올바른 인증번호 였을 경우
    if (msg == "done") {
      // '/home' 스크린으로 이동
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    }
    // 5회 이상 틀렸거나 만료되었을 경우
    else {
      if (msg == 'retry' || msg == 'expired')
        setState(() {
          // 이메일 입력 페이지로 이동
          _authScreenIndex = 0;
        });
      _showSnackBar(msg);
    }
  }

  // 인증번호 입력 페이지에서 재전송 버튼을 눌렀을 때 호출
  Future<void> _requestResendCheckNum() async {
    // 인증 번호 재전송을 서버에 요청
    final msg = await Https.login(_emailController.text, msg: 'resend');
    _showSnackBar(msg);
  }

  // 회원가입 페이지에서 회원가입 버튼을 눌렀을 때 호출
  Future<void> _requestRegister() async {
    final msg = await Https.register(
        _registerEmailController.text, _nickController.text);
    // 회원가입이 되었을 때, 이메일 입력 페이지로 전환
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
