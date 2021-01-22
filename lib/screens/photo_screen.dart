import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:richard_parker/states/board_controller.dart';
import 'package:richard_parker/widgets/posted_image.dart';

class PhotoScreen extends StatelessWidget {
  final BoardController _ = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _.photoScreenScrollController,
          slivers: <Widget>[
            _appbar(),
            Obx(
              () => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return PostedImage(index: index);
                  },
                  childCount: _.photos.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appbar() {
    if (!GetPlatform.isAndroid) {
      return AppBar(
        title: Text(
          '탐색 탭',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return SliverAppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('탐색 탭', style: TextStyle(fontWeight: FontWeight.bold)),
        floating: true,
        snap: true,
      );
    }
  }
}
