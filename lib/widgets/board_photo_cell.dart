import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:richard_parker/states/board_controller.dart';

class BoardPhotoCell extends StatelessWidget {
  final int index;
  final BoardController _ = Get.find();

  BoardPhotoCell({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(_.photos[index] is List
                  ? _.photos[index][0]
                  : _.photos[index]),
            ),
          ),
          child: TextButton(
            onPressed: () {
              _.searchFocusNode.unfocus();
              Get.toNamed('/photo');
            },
            child: null,
          ),
        ),
        _.photos[index] is List
            ? Positioned(
                top: 10,
                right: 10,
                child: Icon(Icons.auto_awesome_motion, color: Colors.white70),
              )
            : SizedBox(),
      ],
    );
  }
}
