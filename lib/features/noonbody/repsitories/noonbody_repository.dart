import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/key_contsts.dart';
import 'package:thunder/core/errors/error_parser.dart';
import 'package:thunder/core/providers/dio_provider.dart';

class NoonbodyRepository {
  final Dio _dio;

  NoonbodyRepository(this._dio);

  Future<void> uploadImage(String imagePath) async {
    final path = '/v1/body/photo';
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imagePath,
        contentType: DioMediaType('image', 'jpeg'),
      ),
    });
    try {
      await _dio.post(
        path,
        data: formData,
        options: Options(
          extra: {KeyConsts.requiresAuth: true},
          contentType: 'multipart/form-data',
        ),
      );
    } on DioException catch (e) {
      throw ErrorParser.parseDio(e);
    }
  }
}

final noonbodyRepositoryProvider = Provider<NoonbodyRepository>((ref) {
  return NoonbodyRepository(ref.read(dioProvider));
});
