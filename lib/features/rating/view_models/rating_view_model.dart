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
  @override
  FutureOr<List<BodyCheckData>> build() async {
    return await _fetchData();
  }

  List<BodyCheckData> generateDummyDatas() {
    return List.generate(
      5,
      (index) => BodyCheckData(
        bodyPhotoId: index,
        imageUrl: 'https://picsum.photos/id/${index + 1}/720/1280',
        memberId: index,
        nickname: '썬더닉네임${index + 1}',
        age: 20 + index,
      ),
    );
  }

  Future<List<BodyCheckData>> _fetchData() async {
    await Future.delayed(const Duration(seconds: 1));
    return generateDummyDatas();
  }

  void refresh() async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(seconds: 2));
    state = await AsyncValue.guard(() async {
      return _fetchData();
    });
  }
}

final bodyCheckListProvider =
    AsyncNotifierProvider<RatingViewModel, List<BodyCheckData>>(
  () => RatingViewModel(),
);
