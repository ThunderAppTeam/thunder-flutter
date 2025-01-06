import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:thunder/features/noonbody/view_models/noonbody_view_model.dart';

class PhotoPreviewController extends StateNotifier<bool> {
  final Ref ref;

  PhotoPreviewController(this.ref) : super(false);

  Future<String?> processCroppedImage({
    required String imagePath,
    required Rect cropRect,
  }) async {
    try {
      state = true; // 처리 시작
      final file = File(imagePath);
      final rawImage = await file.readAsBytes();
      final image = img.decodeImage(rawImage);

      if (image == null) return null;

      final croppedImage = img.copyCrop(
        image,
        x: cropRect.left.toInt(),
        y: cropRect.top.toInt(),
        width: cropRect.width.toInt(),
        height: cropRect.height.toInt(),
      );
      final String croppedImagePath =
          '${file.parent.path}/${DateTime.now().millisecondsSinceEpoch}_cropped.jpg';
      final croppedFile = File(croppedImagePath);
      await croppedFile.writeAsBytes(img.encodeJpg(croppedImage));
      await ref.read(noonbodyProvider.notifier).uploadImage(croppedImagePath);
      return croppedImagePath;
    } catch (e) {
      return null;
    } finally {
      state = false; // 처리 완료
    }
  }
}

final photoPreviewControllerProvider =
    StateNotifierProvider<PhotoPreviewController, bool>((ref) {
  return PhotoPreviewController(ref);
});
