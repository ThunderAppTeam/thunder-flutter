import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/providers/dio_provider.dart';

class NoonbodyRepository {
  final Dio _dio;

  NoonbodyRepository(this._dio);

  Future<void> uploadImage(String imagePath) async {
    // - Request
    // - headers
    //     - Authorization: bearer ${accessToken}
    // - form-data
    print('uploadImage');
    final path = '/v1/body/photo';
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imagePath),
    });
    try {
      await _dio.post(path,
          data: formData,
          // TODO: 토큰 추가
          options: Options(headers: {
            'Authorization': 'bearer ${1}',
          }));
    } on DioException catch (e) {}
  }
}

final noonbodyRepositoryProvider = Provider<NoonbodyRepository>((ref) {
  return NoonbodyRepository(ref.read(dioProvider));
});
