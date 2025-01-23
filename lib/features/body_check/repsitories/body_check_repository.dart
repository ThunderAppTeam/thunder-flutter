import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/key_contst.dart';
import 'package:thunder/core/network/dio_error_parser.dart';
import 'package:thunder/core/network/dio_options.dart';
import 'package:thunder/core/network/dio_provider.dart';

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
        options: DioOptions.multipartTokenOptions,
      );
      final data = response.data[KeyConst.data];
      final imageUrl = data[KeyConst.imageUrl];
      return imageUrl;
    } on DioException catch (e) {
      throw DioErrorParser.parseDio(e);
    }
  }
}

final bodyCheckRepositoryProvider = Provider<BodyCheckRepository>((ref) {
  return BodyCheckRepository(ref.read(dioProvider));
});
