import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/key_contst.dart';
import 'package:thunder/core/network/dio_error_parser.dart';
import 'package:thunder/core/network/dio_options.dart';
import 'package:thunder/core/network/dio_provider.dart';

class BodyCheckRepository {
  final Dio _dio;

  BodyCheckRepository(this._dio);

  Future<Map<String, dynamic>> getBodyCheckResult(int bodyPhotoId) async {
    final path = '/v1/body/photo/$bodyPhotoId';
    try {
      final response = await _dio.get(path, options: DioOptions.tokenOptions);
      final data = response.data[KeyConst.data];
      return data;
    } on DioException catch (e) {
      throw DioErrorParser.parseDio(e);
    }
  }

  Future<void> deleteBodyCheckResult(int bodyPhotoId) async {
    final path = '/v1/body/photo/$bodyPhotoId';
    try {
      await _dio.delete(path, options: DioOptions.tokenOptions);
    } on DioException catch (e) {
      throw DioErrorParser.parseDio(e);
    }
  }
}

final bodyCheckRepositoryProvider = Provider<BodyCheckRepository>((ref) {
  return BodyCheckRepository(ref.read(dioProvider));
});
