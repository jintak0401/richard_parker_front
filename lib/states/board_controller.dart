import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

// BoardScreen과 PhotoScreen의 상태관리 매니저
class BoardController extends GetxController {
  // BoardScreen의 ScrollController
  ScrollController _boardScreenScrollController = ScrollController();
  // PhotoScreen의 ScrollController
  ScrollController _photoScreenScrollController = ScrollController();
  // 이미지 Url이 담긴 List
  RxList<dynamic> _photos;
  // 여러장의 사진을 가진 게시글의 현재 index를 저장
  // 현재 몇 번째 사진인지 보여주기 위함

  RxList<dynamic> _words;

  RxSet _fold = Set().obs;

  RxInt _boardIndex = 0.obs;

  RxMap _imageIndex = {}.obs;
  // searchAppbar에서 뒤로가기 아이콘의 출현을 제어하기 위한 bool
  // 포커스 되었을 때 onSearch: true | 언포커스 되었을 때 onSearch: false
  RxBool _onSearch = false.obs;
  // searchAppbar의 TextField의 focusNode
  FocusNode _searchFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    // 최하단까지 도달하면 사진을 더 load하기 위해 Listener 추가
    _boardScreenScrollController
        .addListener(() => _scrollListener(_boardScreenScrollController));
    _photoScreenScrollController
        .addListener(() => _scrollListener(_photoScreenScrollController));

    // photos 초기화 (임시로 30장 로드)
    initPhoto();
    initWords();
    print(_photos.asMap());

    _searchFocusNode.addListener(_onFocusChange);
  }

  @override
  void onClose() {
    // _boardScreenScrollController.dispose();
    // _photoScreenScrollController.dispose();
    // _searchFocusNode.dispose();
    super.onClose();
  }

  // FocusNode의 상태가 바뀌었을 때 호출되는 함수
  // searchAppbar의 뒤로가기 아이콘 출현을 제어하기 위한 함수
  // 포커스 되었을 때 onSearch: true | 언포커스 되었을 때 onSearch: false
  void _onFocusChange() {
    _onSearch.value = _searchFocusNode.hasFocus;
  }

  void _scrollListener(ScrollController controller) {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      loadMorePhotos();
      loadMoreWords();
    }
  }

  void changeImageIndex({int index, int imageIndex}) {
    _imageIndex[index] = imageIndex;
  }

  // 맨 처음 _photos를 초기화
  void initPhoto() {
    // 임시로 작성한 사진 Url List
    _photos = List.generate(
        30,
        (index) => index % 4 != 0
            ? 'https://picsum.photos/id/$index/200/200'
            : [
                'https://picsum.photos/id/${index + 0}/200/150',
                'https://picsum.photos/id/${index + 1}/200/200',
                'https://picsum.photos/id/${index + 2}/200/150',
                'https://picsum.photos/id/${index + 3}/200/200',
              ]).obs;

    // 사진이 여러장인 경우 사진의 현재 index를 보여주기 위해
    // _imageIndex를 초기화
    for (int i = 0; i < 30; i++) {
      if (i % 4 == 0) {
        _imageIndex[i] = 0;
      }
    }
  }

  void initWords() {
    _words = List.generate(30, (index) => '안녕하세요 ' * Random().nextInt(100)).obs;
  }

  // 사진 추가 로드
  void loadMorePhotos() {
    Future.delayed(Duration(milliseconds: 500), () {
      // 임시로 12장을 더 로드
      final idx = List.generate(12, (index) => _photos.length + index);
      final additionalPhotos = idx
          .map((index) => 'https://picsum.photos/id/${index % 30}/200/200')
          .toList();

      // _photos에 추가 로드한 사진들 추가
      _photos.addAll(additionalPhotos);

      // 여러장일 경우 _imageIndex에도 추가해주어야 함
    });
  }

  void loadMoreWords() {
    final additionalWords =
        List.generate(30, (index) => '안녕하세요 ' * Random().nextInt(100));
    _words.addAll(additionalWords);
  }

  void setFold(int index) {
    _fold.contains(index) ? _fold.remove(index) : _fold.add(index);
  }

  ScrollController get boardScreenScrollController =>
      _boardScreenScrollController;
  ScrollController get photoScreenScrollController =>
      _photoScreenScrollController;
  List get photos => _photos;
  List get words => _words;
  Map get imageIndex => _imageIndex;
  bool get onSearch => _onSearch.value;
  FocusNode get searchFocusNode => _searchFocusNode;
  Set get fold => _fold;
  int get boardIndex => _boardIndex.value;

  set onSearch(bool val) => _onSearch.value = val;
  set boardIndex(int idx) => _boardIndex.value = idx;
}
