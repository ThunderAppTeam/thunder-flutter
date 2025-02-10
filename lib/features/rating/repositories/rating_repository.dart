import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/network/dio_options.dart';
import 'package:thunder/core/network/dio_provider.dart';
import 'package:thunder/core/network/repository/base_repository.dart';

class RatingRepository with BaseRepository {
  @override
  final Dio dio;

  RatingRepository(this.dio);

  Future<List<Map<String, dynamic>>> fetchRatings(int count) async {
    final path = '/v1/body/review';
    final data = await get(path,
        options: DioOptions.tokenOptions, queryParameters: {'size': count});
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> rate(int bodyPhotoId, int score) async {
    final path = '/v1/body/review';
    await post(
      path,
      options: DioOptions.tokenOptions,
      data: {
        'bodyPhotoId': bodyPhotoId,
        'score': score,
      },
    );
  }
}

final ratingRepositoryProvider = Provider<RatingRepository>((ref) {
  return RatingRepository(ref.read(dioProvider));
});
