import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:richard_parker/constants/animation_duration.dart';
import 'package:richard_parker/constants/common_size.dart';
import 'package:richard_parker/states/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController _ = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // 슬라이드 및 탭을 인지하기 위한 GestureDetector
      child: GestureDetector(
        // 메뉴가 열려있을 때, body 를 탭하면 닫힘
        onTap: () {
          if (_.menuStatus == MenuStatus.opened) _.menuStatusChange();
        },
        // 좌우로 슬라이드 중일 때 handling
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          // 슬라이드로 메뉴를 열거나 닫고 있는 중이므로 _menuState 를 middle 로 변경
          _.menuStatus = MenuStatus.middle;
          // 가동범위 이내인지 확인
          if (-_.menuWidth <= (_.bodyXPos + details.primaryDelta) &&
              (_.bodyXPos + details.primaryDelta) <= 0) {
            // 가동범위 이내이면 메뉴를 움직임
            _.bodyXPos += details.primaryDelta;
            _.menuXPos += details.primaryDelta;
          }
        },
        // 슬라이드가 끝났을 때
        onHorizontalDragEnd: (DragEndDetails details) {
          // 절반 이상 열렸을 경우

          if (details.primaryVelocity > _.velocityBoundary) {
            _.menuStatus = MenuStatus.opened;
            _.menuStatusChange();
          } else if (details.primaryVelocity < -_.velocityBoundary) {
            _.menuStatus = MenuStatus.closed;
            _.menuStatusChange();
          }

          if (_.bodyXPos < -_.menuWidth / 2) {
            // closed 로 해주는 이유는 _menuStatusChange() 에서
            // opened 로 바꾸어주게 하기 위함
            _.menuStatus = MenuStatus.closed;
            _.menuStatusChange();
          }
          // 절반 이상 닫혔을 경우
          else if (_.bodyXPos >= -_.menuWidth / 2) {
            // opened 로 해주는 이유는 _menuStatusChange() 에서
            // closed 로 바꾸어주게 하기 위함
            _.menuStatus = MenuStatus.opened;
            _.menuStatusChange();
          }
        },
        child: Stack(
          children: <Widget>[
            _appbar(),
            _body(),
            _sideMenu(),
          ],
        ),
      ),
    );
  }

  Obx _sideMenu() {
    return Obx(
      () => AnimatedPositioned(
        left: _.menuXPos,
        duration: _.menuStatus == MenuStatus.middle ? duringSliding : duration,
        curve: Curves.fastOutSlowIn,
        child: SafeArea(
          child: SizedBox(
            width: _.menuWidth,
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
                    Get.offAllNamed('/auth');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Obx _body() {
    return Obx(
      () => AnimatedContainer(
        duration: _.menuStatus == MenuStatus.middle ? duringSliding : duration,
        width: Get.width,
        padding: const EdgeInsets.only(top: 50),
        transform: Matrix4.translationValues(_.bodyXPos, 0, 0),
        curve: Curves.fastOutSlowIn,
        child: ListView.builder(
          physics: _.menuStatus == MenuStatus.opened
              ? NeverScrollableScrollPhysics()
              : AlwaysScrollableScrollPhysics(),
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
    );
  }

  Obx _appbar() {
    return Obx(
      () => AnimatedPositioned(
        top: 0,
        left: _.bodyXPos,
        duration: _.menuStatus == MenuStatus.middle ? duringSliding : duration,
        curve: Curves.fastOutSlowIn,
        child: Container(
          width: Get.width,
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
                    progress: _.iconAnimationController,
                  ),
                  onPressed: () {
                    _.menuStatusChange();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
