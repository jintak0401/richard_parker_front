import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:richard_parker/states/board_controller.dart';
import 'package:richard_parker/widgets/board_photo_cell.dart';

class BoardScreen extends StatelessWidget {
  final BoardController _ = Get.put(BoardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          // ignore: missing_return
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification) {
              _.searchFocusNode.unfocus();
            }
          },
          child: CustomScrollView(
            controller: _.boardScreenScrollController,
            slivers: <Widget>[
              _searchAppbar(),
              Obx(() => SliverToBoxAdapter(
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      shrinkWrap: true,
                      children: List.generate(_.photos.length,
                          (index) => BoardPhotoCell(index: index)),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchAppbar() {
    return SliverAppBar(
      title: Obx(
        () => TextField(
          focusNode: _.searchFocusNode,
          decoration: InputDecoration(
            icon: GestureDetector(
              onTap: () {
                _.searchFocusNode.unfocus();

                _.searchFocusNode.canRequestFocus = false;

                Future.delayed(Duration(milliseconds: 100), () {
                  _.searchFocusNode.canRequestFocus = true;
                });
              },
              child: Obx(
                () => _.onSearch
                    ? Icon(Icons.arrow_back, color: Colors.black)
                    : SizedBox(),
              ),
            ),
            suffixIcon: Icon(Icons.search, color: Colors.black),
            hintText: '검색',
            filled: true,
            fillColor: Colors.blueGrey,
          ),
        ),
      ),
      floating: true,
      snap: true,
    );
  }
}
