import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/services/analytics_service.dart';
import 'package:thunder/features/rating/models/data/flag_reason_data.dart';
import 'package:thunder/features/rating/repositories/flag_repository.dart';

class FlagViewModel extends AutoDisposeAsyncNotifier<void> {
  late final FlagRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(flagRepositoryProvider);
  }

  Future<List<FlagReasonData>> fetchFlagList() async {
    List<FlagReasonData> result = [];
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final data = await _repository.fetchFlagList();
      result = data.map((e) => FlagReasonData.fromJson(e)).toList();
    });
    return result;
  }

  Future<void> flag(
      int bodyPhotoId, String flagReason, String? otherReason) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.flag(bodyPhotoId, flagReason, otherReason);
      AnalyticsService.reportContent(bodyPhotoId);
    });
  }

  Future<void> block(int memberId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.block(memberId);
      AnalyticsService.blockUser(memberId.toString());
    });
  }
}

final flagViewModelProvider =
    AutoDisposeAsyncNotifierProvider<FlagViewModel, void>(
  () => FlagViewModel(),
);
