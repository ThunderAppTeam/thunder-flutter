import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/errors/server_error.dart';
import 'package:thunder/features/auth/providers/auth_state_provider.dart';
import 'package:thunder/features/rating/models/data/body_check_data.dart';
import 'package:thunder/features/rating/repositories/rating_repository.dart';

class RatingViewModel extends AutoDisposeAsyncNotifier<List<BodyCheckData>> {
  late final RatingRepository _repository;
  List<BodyCheckData> _list = [];
  static const _initialFetchCount = 2;
  static const _fetchCount = 1;
  static const _threshold = 1; // 리스트의 마지막 몇 개 더 전에 가져오기 시작할지.
  final int _maxLength = 2;

  final Duration _refreshDuration = const Duration(milliseconds: 800);

  int _currentIdx = 0;
  int _viewedIdx = 0;
  bool _noMoreData = false;

  int get viewedIdx => _viewedIdx;
  int get viewedBodyPhotoId => _list[_viewedIdx].bodyPhotoId;
  int get viewedMemberId => _list[_viewedIdx].memberId;

  bool _isRatingInProgress = false;

  bool get isRatingInProgress => _isRatingInProgress;

  bool _searching = false;

  bool get searching => _searching;

  bool _needFetchMore() =>
      _currentIdx >= _list.length - _threshold && !_noMoreData;

  @override
  FutureOr<List<BodyCheckData>> build() async {
    _repository = ref.read(ratingRepositoryProvider);

    final link = ref.keepAlive();
    ref.listen(authStateProvider, (prev, next) {
      if (!next.isLoggedIn) {
        link.close(); // 로그아웃 시 강제 해제
      }
    });

    state = const AsyncLoading();
    _list = await _fetchData(_initialFetchCount);
    return _list;
  }

  Future<List<BodyCheckData>> _fetchData(int count) async {
    try {
      final data = await _repository.fetchRatingList(count);
      if (data.length < count) {
        // 요구한 데이터 수보다 적게 가져온 경우
        _noMoreData = true;
      }
      return data.map((e) => BodyCheckData.fromJson(e)).toList();
    } catch (e, st) {
      state = AsyncError(e, st);
      return [];
    }
  }

  void skip() async {
    _currentIdx++;
    if (_needFetchMore()) await _fetchMore();
    _viewedIdx = _currentIdx;
    state = AsyncData(_list);
  }

  void block() async {
    final blockedContents =
        _list.where((e) => e.memberId == _list[_currentIdx].memberId);
    _list.removeWhere((e) => e.memberId == _list[_currentIdx].memberId);
    if (_needFetchMore()) {
      await _fetchMore(count: blockedContents.length);
    }
    state = AsyncData(_list);
  }

  /// 사용자가 "카드 하나를 스와이프/평가"했을 때 호출
  void rate(int rating) async {
    if (_isRatingInProgress) return;
    _isRatingInProgress = true;
    final bodyCheckData = _list[_currentIdx++];
    try {
      await _repository.rate(bodyCheckData.bodyPhotoId, rating);
      if (_needFetchMore()) await _fetchMore();
    } on ServerError catch (e) {
      if (e == ServerError.alreadyReviewed) {
        return; // 이미 평가한 경우 무시
      }
      rethrow;
    } catch (e, st) {
      log('rate error: $e, $st');
      state = AsyncError(e, st);
      return;
    } finally {
      _isRatingInProgress = false;
    }
  }

  /// 추가 데이터 가져오기
  Future<void> _fetchMore({int count = 0}) async {
    final newList = await _fetchData(_fetchCount + count);
    // 새로 가져온 리스트가 < fetchCount 면 이번이 마지막
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
  }

  void completeRating() {
    _viewedIdx = _currentIdx;
    state = AsyncData(_list);
  }

  /// 데이터 전체를 새로고침
  /// 전체 새로고침. "최소 로딩 시간" 보장
  Future<void> refresh() async {
    state = const AsyncLoading();
    _noMoreData = false;
    _currentIdx = 0;
    _list.clear();
    _searching = true;
    // 최소 로딩 시간 보장
    final start = DateTime.now();
    final elapsed = DateTime.now().difference(start);
    final remaining = _refreshDuration - elapsed;
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }
    final fetched = await _fetchData(_initialFetchCount);
    _searching = false;
    _list = fetched;
    state = AsyncData(_list);
  }
}

final ratingViewModelProvider =
    AsyncNotifierProvider.autoDispose<RatingViewModel, List<BodyCheckData>>(
  () => RatingViewModel(),
);
