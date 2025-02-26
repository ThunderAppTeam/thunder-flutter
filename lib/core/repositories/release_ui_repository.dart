import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/key_contst.dart';
import 'package:thunder/core/network/dio_provider.dart';
import 'package:thunder/core/network/repository/base_repository.dart';
import 'package:thunder/core/services/log_service.dart';

class ReleaseUiRepository extends BaseRepository {
  ReleaseUiRepository(super.dio);

  Future<bool> isReleaseUi({
    required String mobileOs,
    required String appVersion,
  }) async {
    final path = "/v1/admin/release-ui";
    try {
      final data = await get(path, queryParameters: {
        KeyConst.mobileOs: mobileOs,
        KeyConst.appVersion: appVersion,
      });
      return data[KeyConst.isReleaseUi];
    } catch (e) {
      LogService.error("isReleaseUi Check Error $e");
      return false;
    }
  }
}

final releaseUiRepositoryProvider = Provider<ReleaseUiRepository>(
  (ref) => ReleaseUiRepository(ref.read(dioProvider)),
);
