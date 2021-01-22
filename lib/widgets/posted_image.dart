import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:richard_parker/states/board_controller.dart';

class PostedImage extends StatelessWidget {
  final int index;
  final BoardController _ = Get.find();

  PostedImage({Key key, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _.photos[index] is List
            // 한 게시글에 여러 사진이 있는 경우
            ? Stack(
                children: <Widget>[
                  _photoBox(),
                  _indexIndicator(),
                ],
              )
            // 한 게시글에 한 사진만 있는 경우
            : CachedNetworkImage(
                width: Get.width,
                imageUrl: _.photos[index] is List
                    ? _.photos[index][0]
                    : _.photos[index],
                fit: BoxFit.fitWidth,
              ),
        SizedBox(height: 20),
      ],
    );
  }

  Container _photoBox() {
    return Container(
      width: Get.width,
      height: Get.width,
      child: PageView(
        children: _.photos[index]
            .map<Widget>(
              (e) => CachedNetworkImage(imageUrl: e, fit: BoxFit.fitWidth),
            )
            .toList(),
        onPageChanged: (int idx) {
          _.changeImageIndex(index: index, imageIndex: idx);
        },
      ),
    );
  }

  Positioned _indexIndicator() {
    return Positioned(
      right: 10,
      top: 10,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.withOpacity(0.3),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 3,
          ),
          child: Obx(
            () => Text(
              '${_.imageIndex[index] + 1}/${_.photos[index].length}',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
