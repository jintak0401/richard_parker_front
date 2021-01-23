import 'package:get/get.dart';

class UserController extends GetxController {
  RxSet _likes = Set().obs;
  Set<int> _additionalDislikes = {};
  Set<int> _additionalLikes = {};

  @override
  void onInit() {
    // 서버로부터 좋아요 받아오기
    initLikes();

    // 서버에 좋아요 전송
    debounce(_likes, (_) {
      // true: 좋아요 | false: 싫어요
      Map<int, bool> body = {};
      _additionalLikes.forEach((element) {
        body[element] = true;
      });
      _additionalDislikes.forEach((element) {
        body[element] = false;
      });
      _additionalLikes.clear();
      _additionalDislikes.clear();

      // body 서버로 전송
      print('body: $body');
      print('likes: $likes');
    });
    super.onInit();
  }

  // 서버로부터 좋아요 받아오기
  void initLikes() {}

  void pressLike(int id) {
    if (_likes.contains(id)) {
      _additionalDislikes.add(id);
      _additionalLikes.remove(id);
      _likes.remove(id);
    } else {
      _additionalDislikes.remove(id);
      _additionalLikes.add(id);
      _likes.add(id);
    }
  }

  Set get likes => _likes;
}
