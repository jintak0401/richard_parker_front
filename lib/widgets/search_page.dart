import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:richard_parker/states/board_controller.dart';

class SearchPage extends StatelessWidget {
  final BoardController _ = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: Obx(
        () => _.onSearch
            ? null
            : Center(child: Icon(Icons.search_rounded, color: Colors.black)),
      ),
    );
  }
}
