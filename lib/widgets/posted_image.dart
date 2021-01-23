import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:richard_parker/constants/animation_duration.dart';
import 'package:richard_parker/constants/common_size.dart';
import 'package:richard_parker/states/board_controller.dart';
import 'package:richard_parker/widgets/rounded_avatar.dart';

import 'file:///C:/Users/jinta/Desktop/richard_parker/lib/states/user_controller.dart';

class PostedImage extends StatelessWidget {
  final int index;
  final BoardController _ = Get.find();
  final UserController _userController = Get.find();

  PostedImage({Key key, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _postHeader(),
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
        _actionButtons(),
        GestureDetector(
          onTap: () {
            _.setFold(index);
          },
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: common_xs_gap),
              child: AnimatedContainer(
                duration: duration,
                width: Get.width,
                child: Obx(() => Text.rich(
                      TextSpan(
                        text: 'username  ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                            text: _.words[index],
                            style: TextStyle(
                                height: 1.7, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      overflow: !_.fold.contains(index)
                          ? TextOverflow.ellipsis
                          : null,
                      textAlign: TextAlign.start,
                    )),
              )),
        ),
        Divider(color: Colors.grey),
      ],
    );
  }

  Row _actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(icon: Icon(Icons.message_outlined), onPressed: () {}),
        IconButton(
          icon: Obx(() => Icon(_userController.likes.contains(index)
              ? Icons.favorite
              : Icons.favorite_border)),
          onPressed: () {
            _userController.pressLike(index);
          },
        ),
      ],
    );
  }

  Row _postHeader() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(common_xxs_gap),
          child: RoundedAvatar(),
        ),
        Expanded(child: Text('username', overflow: TextOverflow.ellipsis)),
        IconButton(icon: Icon(Icons.more_vert_rounded), onPressed: () {})
      ],
    );
  }

  Widget _photoBox() {
    return Container(
      height: Get.width,
      width: Get.width,
      child: PageView(
        children: _.photos[index]
            .map<Widget>(
              (e) => Container(
                child: CachedNetworkImage(imageUrl: e, fit: BoxFit.fitWidth),
              ),
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
