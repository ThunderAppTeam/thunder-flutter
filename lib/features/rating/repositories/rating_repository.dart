import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/key_contst.dart';
import 'package:thunder/core/network/dio_error_parser.dart';
import 'package:thunder/core/network/dio_options.dart';
import 'package:thunder/core/network/dio_provider.dart';

class RatingRepository {
  final Dio _dio;

  RatingRepository(this._dio);

  // 이전 공통 대기열 기준 API
  // Future<List<Map<String, dynamic>>> fetchRatingList(int refreshCount) async {
  //   final path = '/v1/body/review/refresh';
  //   try {
  //     final response = await _dio.post(
  //       path,
  //       options: DioOptions.tokenOptions,
  //       queryParameters: {'refreshCount': refreshCount},
  //     );
  //     final data = response.data[KeyConst.data];
  //     return List<Map<String, dynamic>>.from(data);
  //   } on DioException catch (e) {
  //     throw DioErrorParser.parseDio(e);
  //   }
  // }

  Future<List<Map<String, dynamic>>> fetchRatings(int count) async {
    final path = '/v1/body/review';
    try {
      final response = await _dio.get(path,
          options: DioOptions.tokenOptions, queryParameters: {'size': count});
      final data = response.data[KeyConst.data];
      return List<Map<String, dynamic>>.from(data);
    } on DioException catch (e) {
      throw DioErrorParser.parseDio(e);
    }
  }

  Future<void> rate(int bodyPhotoId, int score) async {
    final path = '/v1/body/review';
    try {
      await _dio.post(path, options: DioOptions.tokenOptions, data: {
        'bodyPhotoId': bodyPhotoId,
        'score': score,
      });
    } on DioException catch (e) {
      throw DioErrorParser.parseDio(e);
    }
  }
}

final ratingRepositoryProvider = Provider<RatingRepository>((ref) {
  return RatingRepository(ref.read(dioProvider));
});
