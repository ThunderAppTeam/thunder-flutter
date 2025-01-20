import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class BodyCheckData {
  final int bodyPhotoId;
  final String imageUrl;
  final int memberId;
  final String nickname;
  final int age;

  BodyCheckData({
    required this.bodyPhotoId,
    required this.imageUrl,
    required this.memberId,
    required this.nickname,
    required this.age,
  });
}

class RatingViewModel extends AsyncNotifier<List<BodyCheckData>> {
  final List<BodyCheckData> _list = [];
  @override
  FutureOr<List<BodyCheckData>> build() async {
    addDummyDatas();
    return _list;
  }

  void addDummyDatas() {
    _list.addAll(List.generate(
      5,
      (index) => BodyCheckData(
        bodyPhotoId: index,
        imageUrl: 'https://picsum.photos/id/${index + 1}/720/1280',
        memberId: index,
        nickname: '썬더닉네임$index',
        age: 20 + index,
      ),
    ));
  }
}

final bodyCheckListProvider =
    AsyncNotifierProvider<RatingViewModel, List<BodyCheckData>>(
  () => RatingViewModel(),
);
