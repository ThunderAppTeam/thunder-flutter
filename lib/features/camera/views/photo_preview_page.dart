import 'dart:io';

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:image/image.dart' as img;
import 'package:thunder/core/theme/constants/styles.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/features/camera/views/cropped_image_preview_page.dart';

class PhotoPreviewPage extends StatefulWidget {
  final String imagePath;

  const PhotoPreviewPage({super.key, required this.imagePath});

  @override
  State<PhotoPreviewPage> createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage> {
  final GlobalKey<ExtendedImageEditorState> _editorKey =
      GlobalKey<ExtendedImageEditorState>();

  @override
  Widget build(BuildContext context) {
    final file = File(widget.imagePath);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: '사진 미리보기',
          actionText: '완료',
          onAction: () => _cropImage(context),
        ),
        body: Center(
          child: AspectRatio(
            aspectRatio: Styles.imageAspectRatio,
            child: ExtendedImage.file(
              file,
              fit: BoxFit.contain,
              mode: ExtendedImageMode.editor,
              extendedImageEditorKey: _editorKey,
              initEditorConfigHandler: (state) {
                return EditorConfig(
                  cropRectPadding: EdgeInsets.zero,
                  initCropRectType: InitCropRectType.layoutRect,
                  cropAspectRatio: Styles.imageAspectRatio,
                  maxScale: 4.0, // 최대 확대 배율
                  cornerColor: Colors.transparent,
                  lineColor: Colors.transparent,
                  hitTestBehavior: HitTestBehavior.deferToChild,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _cropImage(BuildContext context) async {
    final editorState = _editorKey.currentState;
    if (editorState == null) return;

    // 크롭 영역 가져오기
    final Rect? cropRect = editorState.getCropRect();
    if (cropRect == null) return;

    // 원본 이미지 불러오기
    final file = File(widget.imagePath);
    final rawImage = await file.readAsBytes();
    final image = img.decodeImage(rawImage);

    if (image == null) return;

    // 크롭된 이미지 생성
    final croppedImage = img.copyCrop(
      image,
      x: cropRect.left.toInt(),
      y: cropRect.top.toInt(),
      width: cropRect.width.toInt(),
      height: cropRect.height.toInt(),
    );

    // 리사이즈
    img.Image resizedImage = croppedImage;
    if (croppedImage.width > 1080 || croppedImage.height > 1920) {
      resizedImage = img.copyResize(
        croppedImage,
        width: 1080,
        height: 1920,
      );
    }
    // 압축하여 저장
    final compressedFilePath =
        '${file.path}_compressed${DateTime.now().millisecondsSinceEpoch}.jpg';
    final compressedFile = File(compressedFilePath)
      ..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 75));

    // 다음 화면으로 이동하며 데이터 전달
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CroppedImagePreviewPage(
          compressedFile: compressedFile,
          originalImage: image,
          croppedImage: croppedImage,
          resizedImage: resizedImage,
        ),
      ),
    );
  }
}
