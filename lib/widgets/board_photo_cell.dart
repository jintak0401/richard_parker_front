import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:richard_parker/states/board_controller.dart';

// BoardScreen의 각 이미지 셀 위젯
class BoardPhotoCell extends StatelessWidget {
  // controller의 photos에서 몇 번째 index인지
  final int index;
  final BoardController _ = Get.find();

  BoardPhotoCell({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 스택으로 TextButton을 이용해 ripple 효과 줌
    return Stack(
      children: <Widget>[
        // width와 height로 그리드 꽉 채움
        // 해주지 않으면 빈 공간 생김
        Container(
          width: Get.width / 3,
          height: Get.width / 3,
          // BoxDecoration을 이용해 background 이미지 적용
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                _.photos[index] is List ? _.photos[index][0] : _.photos[index],
              ),
              fit: BoxFit.cover,
            ),
          ),
          // ripple 효과를 위한 TextButton
          child: TextButton(
            onPressed: () {
              _.searchFocusNode.unfocus();
              Get.toNamed('/photo');
            },
            child: null,
          ),
        ),
        // 여러장일 경우 우측 상단에 아이콘 배치
        _.photos[index] is List
            ? Positioned(
                top: 10,
                right: 10,
                child: Icon(Icons.auto_awesome_motion, color: Colors.white70),
              )
            : null,
      ].where((element) => element != null).toList(),
    );
  }
}
