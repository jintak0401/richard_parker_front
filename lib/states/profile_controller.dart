import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:richard_parker/constants/animation_duration.dart';

// opened: 완전히 메뉴창이 열린 상태
// closed: 완전히 메뉴창이 닫힌 상태
// middle: 슬라이드로 메뉴창을 열거나 닫고 있는 중간상태
// middle 이 있는 이유는 AnimatedPositioned 에서 duration 을 위함
enum MenuStatus { opened, closed, middle }

class ProfileController extends GetxController
    with SingleGetTickerProviderMixin {
  // 사이드 메뉴의 width
  final double _menuWidth = Get.width * 3 / 5;
  // 메뉴가 닫혔을 때: 0 | 열렸을 때: -menuWith
  RxDouble _bodyXPos = 0.0.obs;
  // 메뉴가 닫혔을 때: size.width | 열렸을 때: size.width - menuWith
  RxDouble _menuXPos = Get.width.obs;
  // 사이드 메뉴를 여는 appbar 의 오른쪽 버튼의 애니메이션 컨트롤러
  AnimationController _iconAnimationController;
  // 메뉴 초기상태: 완전히 닫힌 상태
  Rx<MenuStatus> _menuStatus = MenuStatus.closed.obs;

  final double _velocityBoundary = 400.0;

  @override
  void onInit() {
    super.onInit();
    _iconAnimationController =
        AnimationController(vsync: this, duration: duration);
  }

  // 메뉴가 열리고 닫힐 때
  // 메뉴와 관련된 상태들 변화
  void menuStatusChange() {
    // 열린 상태에서 닫힌 상태로
    if (_menuStatus == MenuStatus.opened.obs) {
      _menuStatus = MenuStatus.closed.obs;
      _bodyXPos.value = 0;
      _menuXPos.value = Get.width;
      _iconAnimationController.reverse();
    }
    // 닫힌 상태에서 열린 상태로
    else {
      _menuStatus = MenuStatus.opened.obs;
      _bodyXPos.value = -_menuWidth;
      _menuXPos.value = Get.width - _menuWidth;
      _iconAnimationController.forward();
    }
  }

  double get menuWidth => _menuWidth;
  double get bodyXPos => _bodyXPos.value;
  double get menuXPos => _menuXPos.value;
  AnimationController get iconAnimationController => _iconAnimationController;
  MenuStatus get menuStatus => _menuStatus.value;
  double get velocityBoundary => _velocityBoundary;

  set bodyXPos(double offset) => _bodyXPos.value = offset;
  set menuXPos(double offset) => _menuXPos.value = offset;
  set menuStatus(MenuStatus status) => _menuStatus.value = status;
}
