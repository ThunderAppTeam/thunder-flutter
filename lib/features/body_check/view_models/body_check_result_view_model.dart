import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/features/body_check/models/data/body_check_result.dart';
import 'package:thunder/features/body_check/repsitories/body_check_repository.dart';

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
    state = AsyncData(await _fetchBodyCheckResult(bodyPhotoId));
  }
}

final bodyCheckResultProvider = AsyncNotifierProvider.autoDispose
    .family<BodyCheckResultViewModel, BodyCheckResult, int>(
  () => BodyCheckResultViewModel(),
);
