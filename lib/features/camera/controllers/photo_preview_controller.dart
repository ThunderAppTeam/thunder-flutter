import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:thunder/core/constants/image_consts.dart';
import 'package:thunder/core/utils/image_utils.dart';

class PhotoPreviewController extends StateNotifier<bool> {
  PhotoPreviewController() : super(false);

  Future<String?> processCroppedImage({
    required String imagePath,
    required Rect cropRect,
  }) async {
    try {
      state = true; // 처리 시작
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      await logImageInfo('Original Image', bytes);
      final image = img.decodeImage(bytes);
      if (image == null) return null;
      final croppedImage = img.copyCrop(
        image,
        x: cropRect.left.toInt(),
        y: cropRect.top.toInt(),
        width: cropRect.width.toInt(),
        height: cropRect.height.toInt(),
      );
      final croppedBytes = img.encodeJpg(croppedImage);
      await logImageInfo('Cropped Image', croppedBytes);
      final compressed = await FlutterImageCompress.compressWithList(
        croppedBytes,
        quality: ImageConsts.targetQuality,
      );
      await logImageInfo('Compressed Image', compressed);
      await file.writeAsBytes(compressed);
      return imagePath;
    } catch (e) {
      return null;
    } finally {
      state = false; // 처리 완료
    }
  }
}

final photoPreviewControllerProvider =
    StateNotifierProvider<PhotoPreviewController, bool>((ref) {
  return PhotoPreviewController();
});
