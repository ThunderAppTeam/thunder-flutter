import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/key_contsts.dart';
import 'package:thunder/core/errors/error_parser.dart';
import 'package:thunder/core/providers/dio_provider.dart';

class BodyCheckRepository {
  final Dio _dio;

  BodyCheckRepository(this._dio);

  Future<String?> uploadImage(String imagePath) async {
    log('upload Image: $imagePath');
    final path = '/v1/body/photo';
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imagePath,
        contentType: DioMediaType('image', 'jpeg'),
      ),
    });
    try {
      final response = await _dio.post(
        path,
        data: formData,
        options: Options(
          extra: {KeyConsts.requiresAuth: true},
          contentType: 'multipart/form-data',
        ),
      );
      final data = response.data[KeyConsts.data];
      final imageUrl = data[KeyConsts.imageUrl];
      return imageUrl;
    } on DioException catch (e) {
      throw ErrorParser.parseDio(e);
    }
  }
}

final bodyCheckRepositoryProvider = Provider<BodyCheckRepository>((ref) {
  return BodyCheckRepository(ref.read(dioProvider));
});
