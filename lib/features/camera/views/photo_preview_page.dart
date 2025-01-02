import 'dart:io';

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/constants/image_consts.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/features/noonbody/view_models/noonbody_view_model.dart';

class PhotoPreviewPage extends ConsumerStatefulWidget {
  final String imagePath;

  const PhotoPreviewPage({super.key, required this.imagePath});

  @override
  ConsumerState<PhotoPreviewPage> createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends ConsumerState<PhotoPreviewPage> {
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
          onAction: () => _onComplete(widget.imagePath, ref),
        ),
        body: Center(
          child: AspectRatio(
            aspectRatio: ImageConsts.aspectRatio,
            child: ExtendedImage.file(
              file,
              fit: BoxFit.contain,
              mode: ExtendedImageMode.editor,
              extendedImageEditorKey: _editorKey,
              initEditorConfigHandler: (state) {
                return EditorConfig(
                  cropRectPadding: EdgeInsets.zero,
                  initCropRectType: InitCropRectType.layoutRect,
                  cropAspectRatio: ImageConsts.aspectRatio,
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

  Future<void> _onComplete(String imagePath, WidgetRef ref) async {
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

    // 크롭된 이미지를 새로운 경로로 저장
    final String croppedImagePath =
        '${file.parent.path}/${DateTime.now().millisecondsSinceEpoch}_cropped.jpg';
    final croppedFile = File(croppedImagePath);
    await croppedFile.writeAsBytes(img.encodeJpg(croppedImage));

    await ref.read(noonbodyProvider.notifier).uploadImage(croppedImagePath);
    if (mounted) {
      // 자른 이미지의 path를 전달
      SafeRouter.goNamed(
        context,
        Routes.noonbody.name,
        extra: croppedImagePath,
      );
    }
  }
}
