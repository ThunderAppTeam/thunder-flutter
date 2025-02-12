import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/services/log_service.dart';
import 'package:thunder/core/theme/constants/styles.dart';
import 'package:thunder/features/archive/models/data/body_check_preview_data.dart';
import 'package:thunder/features/archive/repositories/archive_repository.dart';
import 'package:thunder/features/body_check/view_models/body_check_result_view_model.dart';

class ArchiveViewModel
    extends AutoDisposeAsyncNotifier<List<BodyCheckPreviewData>> {
  late final ArchiveRepository _repository;
  List<BodyCheckPreviewData> _list = [];

  @override
  Future<List<BodyCheckPreviewData>> build() async {
    _repository = ref.read(archiveRepositoryProvider);
    state = const AsyncLoading();
    _list = await _fetchArchive();
    return _list;
  }

  Future<List<BodyCheckPreviewData>> _fetchArchive() async {
    try {
      final archive = await _repository.fetchArchive();
      return archive.map((e) => BodyCheckPreviewData.fromJson(e)).toList();
    } catch (e) {
      LogService.error('error: $e');
      throw Exception('Failed to fetch archive');
    }
  }

  Future<void> refresh({bool keepPreviousData = false}) async {
    if (keepPreviousData) {
      state = const AsyncValue<List<BodyCheckPreviewData>>.loading()
          .copyWithPrevious(state);
    } else {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(
      () async {
        _list = await _fetchArchive();
        return _list;
      },
    );
  }

  void removeItem(int bodyPhotoId) {
    _list.removeWhere((element) => element.bodyPhotoId == bodyPhotoId);
    state = AsyncData(_list);
  }

  Future<bool> checkBodyCheckExist(int bodyPhotoId) async {
    final link =
        ref.read(bodyCheckResultProvider(bodyPhotoId).notifier).ref.keepAlive();
    try {
      await ref.read(bodyCheckResultProvider(bodyPhotoId).future);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    } finally {
      Future.delayed(Styles.pageTransitionDuration500 * 2, () {
        link.close();
      });
    }
  }
}

final archiveViewModelProvider = AutoDisposeAsyncNotifierProvider<
    ArchiveViewModel, List<BodyCheckPreviewData>>(
  () => ArchiveViewModel(),
);
