import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/network/dio_options.dart';
import 'package:thunder/core/network/dio_provider.dart';
import 'package:thunder/core/network/repository/base_repository.dart';

class BodyCheckRepository with BaseRepository {
  @override
  final Dio dio;

  BodyCheckRepository(this.dio);

  Future<Map<String, dynamic>> getBodyCheckResult(int bodyPhotoId) async {
    final path = '/v1/body/photo/$bodyPhotoId';
    return get(path, options: DioOptions.tokenOptions);
  }

  Future<void> deleteBodyCheckResult(int bodyPhotoId) async {
    final path = '/v1/body/photo/$bodyPhotoId';
    await delete(path, options: DioOptions.tokenOptions);
  }
}

final bodyCheckRepositoryProvider = Provider<BodyCheckRepository>((ref) {
  return BodyCheckRepository(ref.read(dioProvider));
});
