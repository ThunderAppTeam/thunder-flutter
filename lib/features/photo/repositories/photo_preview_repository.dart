import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/network/dio_options.dart';
import 'package:thunder/core/network/dio_provider.dart';
import 'package:thunder/core/network/repository/base_repository.dart';

class PhotoPreviewRepository extends BaseRepository {
  PhotoPreviewRepository(super.dio);

  Future<Map<String, dynamic>> uploadImage(String imagePath) async {
    final path = '/v1/body/photo';
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imagePath,
        contentType: DioMediaType('image', 'jpeg'),
      ),
    });
    return post(path,
        options: DioOptions.multipartTokenOptions, data: formData);
  }
}

final photoPreviewRepositoryProvider = Provider<PhotoPreviewRepository>((ref) {
  return PhotoPreviewRepository(ref.read(dioProvider));
});
