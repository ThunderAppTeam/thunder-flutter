import 'package:extended_image/extended_image.dart' as extended_image;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/services/analytics_service.dart';
import 'package:thunder/features/body_check/models/data/body_check_result.dart';
import 'package:thunder/features/body_check/repositories/body_check_repository.dart';

class BodyCheckResultViewModel
    extends AutoDisposeFamilyAsyncNotifier<BodyCheckResult, int> {
  late final BodyCheckRepository _repository;

  @override
  Future<BodyCheckResult> build(int arg) async {
    _repository = ref.read(bodyCheckRepositoryProvider);
    state = const AsyncLoading();
    final result = await _fetchBodyCheckResult(arg);
    return result;
  }

  Future<BodyCheckResult> _fetchBodyCheckResult(int bodyPhotoId) async {
    try {
      final data = await _repository.getBodyCheckResult(bodyPhotoId);
      return BodyCheckResult.fromJson(data);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> refresh() async {
    final bodyPhotoId = state.valueOrNull?.bodyPhotoId;
    if (bodyPhotoId == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchBodyCheckResult(bodyPhotoId));
  }

  Future<bool> deleteBodyCheckResult() async {
    final bodyPhotoId = state.valueOrNull?.bodyPhotoId;
    final url = state.valueOrNull?.imageUrl;
    if (bodyPhotoId == null || url == null) return false;
    state = const AsyncLoading();
    try {
      await _repository.deleteBodyCheckResult(bodyPhotoId);
      AnalyticsService.deleteContent(bodyPhotoId);
      await extended_image.clearDiskCachedImage(url);
      extended_image.clearMemoryImageCache(url);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }
}

final bodyCheckResultProvider = AsyncNotifierProvider.autoDispose
    .family<BodyCheckResultViewModel, BodyCheckResult, int>(
  () => BodyCheckResultViewModel(),
);
