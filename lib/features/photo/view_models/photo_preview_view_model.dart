import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:thunder/core/constants/image_const.dart';
import 'package:thunder/core/services/analytics_service.dart';
import 'package:thunder/core/utils/image_utils.dart';
import 'package:thunder/features/photo/models/data/image_data.dart';
import 'package:thunder/features/photo/repositories/photo_preview_repository.dart';

class PhotoPreviewViewModel extends AsyncNotifier<void> {
  late final PhotoPreviewRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(photoPreviewRepositoryProvider);
    return null;
  }

  Future<ImageData?> cropAndUploadImage({
    required String imagePath,
    required Rect cropRect,
  }) async {
    state = const AsyncValue.loading();
    ImageData? imageData;
    state = await AsyncValue.guard(() async {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) throw Exception('Failed to decode image');
      final croppedImage = img.copyCrop(
        image,
        x: cropRect.left.toInt(),
        y: cropRect.top.toInt(),
        width: cropRect.width.toInt(),
        height: cropRect.height.toInt(),
      );

      final croppedBytes = img.encodeJpg(croppedImage);
      final compressed = await FlutterImageCompress.compressWithList(
        croppedBytes,
        quality: ImageConst.targetQuality,
      );
      if (kDebugMode) await logImageInfo('Output Image', compressed);
      await file.writeAsBytes(compressed);
      final response = await _repository.uploadImage(imagePath);
      imageData = ImageData.fromJson(response);
      // 업로드 성공 시 파일 삭제
      await file.delete();
      AnalyticsService.uploadPhoto();
    });
    return imageData;
  }
}

final photoPreviewProvider = AsyncNotifierProvider<PhotoPreviewViewModel, void>(
  () => PhotoPreviewViewModel(),
);
