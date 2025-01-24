import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/key_contst.dart';
import 'package:thunder/core/network/dio_options.dart';
import 'package:thunder/core/network/dio_provider.dart';

class ArchiveRepository {
  final Dio _dio;

  ArchiveRepository(this._dio);

  Future<List<Map<String, dynamic>>> fetchArchive() async {
    final path = '/v1/body/photo';
    final response = await _dio.get(
      path,
      options: DioOptions.tokenOptions,
    );
    final data = response.data[KeyConst.data];
    return List<Map<String, dynamic>>.from(data);
  }
}

final archiveRepositoryProvider = Provider<ArchiveRepository>((ref) {
  return ArchiveRepository(ref.read(dioProvider));
});
