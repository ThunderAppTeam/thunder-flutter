import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/features/rating/models/data/body_check_data.dart';
import 'package:thunder/features/rating/repositories/rating_repository.dart';

class RatingViewModel extends AutoDisposeAsyncNotifier<List<BodyCheckData>> {
  late final RatingRepository _repository;
  List<BodyCheckData> _list = [];

  static const _fetchCount = 5;
  final int _maxLength = 10;
  final int _threshold = 2;

  final Duration _refreshDuration = const Duration(milliseconds: 800);

  int _currentIdx = 0;
  bool _noMoreData = false;

  int get currentIdx => _currentIdx;

  bool _isRatingInProgress = false;

  bool get isRatingInProgress => _isRatingInProgress;

  @override
  FutureOr<List<BodyCheckData>> build() async {
    _repository = ref.read(ratingRepositoryProvider);
    state = const AsyncLoading();
    _list = await _fetchData();
    if (_list.length < _fetchCount) {
      _noMoreData = true;
    }
    return _list;
  }

  Future<List<BodyCheckData>> _fetchData() async {
    try {
      final response = await _repository.fetchRatingList(_fetchCount);
      return response.map((e) => BodyCheckData.fromJson(e)).toList();
    } catch (e, st) {
      state = AsyncError(e, st);
      return [];
    }
  }

  /// 사용자가 "카드 하나를 스와이프/평가"했을 때 호출
  void rate(int rating) async {
    if (_isRatingInProgress) return;
    _isRatingInProgress = true;
    final bodyCheckData = _list[_currentIdx++];
    try {
      await _repository.rate(bodyCheckData.bodyPhotoId, rating);
    } catch (e, st) {
      state = AsyncError(e, st);
      return;
    }
    if (_currentIdx >= _list.length - _threshold) {
      await _fetchMore();
    }
    _isRatingInProgress = false;
  }

  /// 추가 데이터 가져오기
  Future<void> _fetchMore() async {
    if (_noMoreData) return;
    final newList = await _fetchData();
    // 새로 가져온 리스트가 < fetchCount 면 이번이 마지막
    if (newList.length < _fetchCount) _noMoreData = true;
    // 기존 리스트 뒤에 덧붙임
    _list.addAll(newList);
    if (_list.length > _maxLength) {
      final overflow = _list.length - _maxLength;
      _list.removeRange(0, overflow);
      _currentIdx -= overflow;
      if (_currentIdx < 0) {
        _currentIdx = 0;
      }
    }
    state = AsyncData(_list);
  }

  /// 데이터 전체를 새로고침
  /// 전체 새로고침. "최소 로딩 시간" 보장
  Future<void> refresh() async {
    state = const AsyncLoading();
    _noMoreData = false;
    _currentIdx = 0;
    _list.clear();

    // 최소 로딩 시간 보장
    final start = DateTime.now();
    final fetched = await _fetchData();
    final elapsed = DateTime.now().difference(start);
    final remaining = _refreshDuration - elapsed;
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }

    _list = fetched;
    if (_list.length < _fetchCount) {
      _noMoreData = true;
    }
    state = AsyncData(_list);
  }
}

final ratingViewModelProvider =
    AutoDisposeAsyncNotifierProvider<RatingViewModel, List<BodyCheckData>>(
  () => RatingViewModel(),
);
