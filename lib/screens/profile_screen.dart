import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:richard_parker/constants/animation_duration.dart';
import 'package:richard_parker/constants/common_size.dart';
import 'package:richard_parker/constants/screen_size.dart';

// opened: 완전히 메뉴창이 열린 상태
// closed: 완전히 메뉴창이 닫힌 상태
// middle: 슬라이드로 메뉴창을 열거나 닫고 있는 중간상태
// middle 이 있는 이유는 AnimatedPositioned 에서 duration 을 위함
enum MenuStatus { opened, closed, middle }

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  // 사이드 메뉴를 여는 appbar 의 오른쪽 버튼의 애니메이션 컨트롤러
  AnimationController _iconAnimationController;
  // 메뉴 초기상태: 완전히 닫힌 상태
  MenuStatus _menuStatus = MenuStatus.closed;

  // 사이드 메뉴의 width
  final menuWidth = size.width * 3 / 5;
  // 메뉴가 닫혔을 때: 0 | 열렸을 때: -menuWith
  double bodyXPos = 0;
  // 메뉴가 닫혔을 때: size.width | 열렸을 때: size.width - menuWith
  double menuXPos = size.width;

  @override
  void initState() {
    super.initState();
    _iconAnimationController =
        AnimationController(vsync: this, duration: duration);
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // 슬라이드 및 탭을 인지하기 위한 GestureDetector
      child: GestureDetector(
        // 메뉴가 열려있을 때, body 를 탭하면 닫힘
        onTap: () {
          if (_menuStatus == MenuStatus.opened) _menuStatusChange();
        },
        // 좌우로 슬라이드 중일 때 handling
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          // 슬라이드로 메뉴를 열거나 닫고 있는 중이므로 _menuState 를 middle 로 변경
          setState(() {
            _menuStatus = MenuStatus.middle;
          });
          // 가동범위 이내인지 확인
          if (-menuWidth <= (bodyXPos + details.primaryDelta) &&
              (bodyXPos + details.primaryDelta) <= 0) {
            // 가동범위 이내이면 메뉴를 움직임
            setState(() {
              bodyXPos += details.primaryDelta;
              menuXPos += details.primaryDelta;
            });
          }
        },
        // 슬라이드가 끝났을 때
        onHorizontalDragEnd: (DragEndDetails details) {
          // 절반 이상 열렸을 경우
          if (bodyXPos < -menuWidth / 2) {
            // closed 로 해주는 이유는 _menuStatusChange() 에서
            // opened 로 바꾸어주게 하기 위함
            setState(() {
              _menuStatus = MenuStatus.closed;
            });
            _menuStatusChange();
          }
          // 절반 이상 닫혔을 경우
          else if (bodyXPos >= -menuWidth / 2) {
            // opened 로 해주는 이유는 _menuStatusChange() 에서
            // closed 로 바꾸어주게 하기 위함
            setState(() {
              _menuStatus = MenuStatus.opened;
            });
            _menuStatusChange();
          }
        },
        child: Stack(
          children: <Widget>[
            // appbar
            AnimatedPositioned(
              top: 0,
              left: bodyXPos,
              child: _appbar(),
              duration:
                  _menuStatus == MenuStatus.middle ? duringSliding : duration,
              curve: Curves.fastOutSlowIn,
            ),
            // body
            AnimatedContainer(
              duration:
                  _menuStatus == MenuStatus.middle ? duringSliding : duration,
              width: size.width,
              padding: const EdgeInsets.only(top: 50),
              transform: Matrix4.translationValues(bodyXPos, 0, 0),
              curve: Curves.fastOutSlowIn,
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (BuildContext context, int index) {
                  return index % 2 == 0
                      ? Container(
                          height: 100,
                          color: Colors.blueAccent,
                        )
                      : Container(
                          height: 100,
                          color: Colors.redAccent,
                        );
                },
              ),
            ),
            // sideMenu
            AnimatedPositioned(
              child: SafeArea(
                child: SizedBox(
                  width: menuWidth,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          '유저 닉네임',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.exit_to_app,
                          color: Colors.black87,
                        ),
                        title: Text(
                          '로그아웃',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/auth', (Route<dynamic> route) => false);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              left: menuXPos,
              duration:
                  _menuStatus == MenuStatus.middle ? duringSliding : duration,
              curve: Curves.fastOutSlowIn,
            ),
          ],
        ),
      ),
    );
  }

  // 메뉴가 열리고 닫힐 때
  // 메뉴와 관련된 상태들 변화
  void _menuStatusChange() {
    setState(() {
      _menuStatus = _menuStatus == MenuStatus.opened
          ? MenuStatus.closed
          : MenuStatus.opened;
      if (_menuStatus == MenuStatus.opened) {
        bodyXPos = -menuWidth;
        menuXPos = size.width - menuWidth;
        _iconAnimationController.forward();
      } else {
        bodyXPos = 0;
        menuXPos = size.width;
        _iconAnimationController.reverse();
      }
    });
  }

  Widget _appbar() {
    return Container(
      width: size.width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: common_xxl_gap),
              child: Text(
                '프로필 관리',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: _iconAnimationController,
              ),
              onPressed: () {
                _menuStatusChange();
              })
        ],
      ),
    );
  }
}
