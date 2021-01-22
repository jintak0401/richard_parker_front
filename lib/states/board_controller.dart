import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BoardController extends GetxController {
  ScrollController _boardScreenScrollController;
  ScrollController _photoScreenScrollController;
  RxList<dynamic> _photos;
  RxMap _postedImageController = {}.obs;
  RxMap _imageIndex = {}.obs;
  RxBool _onSearch = false.obs;
  Rx<FocusNode> _searchFocusNode;

  @override
  void onInit() {
    super.onInit();
    _boardScreenScrollController = ScrollController();
    _photoScreenScrollController = ScrollController();
    _boardScreenScrollController
        .addListener(() => _scrollListener(_boardScreenScrollController));
    _photoScreenScrollController
        .addListener(() => _scrollListener(_photoScreenScrollController));
    _photos = List.generate(
        30,
        (index) => index % 4 != 0
            ? 'https://picsum.photos/id/$index/200/200'
            : [
                'https://picsum.photos/id/${index + 0}/200/200',
                'https://picsum.photos/id/${index + 1}/200/200',
                'https://picsum.photos/id/${index + 2}/200/200',
                'https://picsum.photos/id/${index + 3}/200/200',
              ]).obs;
    for (int i = 0; i < 30; i++) {
      if (i % 4 == 0) {
        _imageIndex[i] = 0;
        _postedImageController[i] = PageController();
      }
    }
    _searchFocusNode = FocusNode().obs;
    _searchFocusNode.value.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    print(_searchFocusNode.value.hasFocus);
    _onSearch.value = _searchFocusNode.value.hasFocus;
  }

  void _scrollListener(ScrollController controller) {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      Future.delayed(Duration(milliseconds: 500), () {
        final idx = List.generate(12, (index) => _photos.length + index);
        for (int index in idx) {
          _photos.add('https://picsum.photos/id/${index % 30}/200/200');
        }
      });
    }
  }

  void changeImageIndex({int index, int imageIndex}) {
    _imageIndex[index] = imageIndex;
  }

  ScrollController get boardScreenScrollController =>
      _boardScreenScrollController;
  ScrollController get photoScreenScrollController =>
      _photoScreenScrollController;
  List get photos => _photos;
  Map get postedImageController => _postedImageController;
  Map get imageIndex => _imageIndex;
  bool get onSearch => _onSearch.value;
  FocusNode get searchFocusNode => _searchFocusNode.value;

  set onSearch(bool val) => _onSearch.value = val;
}
