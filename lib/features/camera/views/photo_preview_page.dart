import 'dart:io';

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:image/image.dart' as img;
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/theme/constants/styles.dart';
import 'package:thunder/core/utils/%08image_utils.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';

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
          onAction: () => _cropImage(widget.imagePath),
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

  Future<void> _cropImage(String imagePath) async {
    final editorState = _editorKey.currentState;
    if (editorState == null) return;

    // 크롭 영역 가져오기
    final Rect? cropRect = editorState.getCropRect();
    if (cropRect == null) return;

    // 원본 이미지 불러오기
    final file = File(imagePath);
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
    if (mounted) {
      showModalBottomSheet(
        context: context,
        builder: (context) => CustomBottomSheet(
          title: '사진 미리보기',
          subtitle:
              '이미지 용량: ${formatFileSize(croppedImage.length)}\n이미지 크기: ${croppedImage.width}x${croppedImage.height}',
        ),
      );
      // SafeRouter.goNamed(context, Routes.home.name);
    }
  }
}
