import 'dart:io';

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/constants/image_consts.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/features/camera/controllers/photo_preview_controller.dart';

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
    final isProcessing = ref.watch(photoPreviewControllerProvider);
    final isNavigating = ref.watch(safeRouterProvider).isNavigating;
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: '사진 미리보기',
          actionText: '완료',
          onAction: isProcessing || isNavigating
              ? null
              : () => _onComplete(widget.imagePath),
        ),
        body: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: ImageConsts.aspectRatio,
                child: ExtendedImage.file(
                  File(widget.imagePath),
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.editor,
                  extendedImageEditorKey: _editorKey,
                  initEditorConfigHandler: (state) {
                    return EditorConfig(
                      cropRectPadding: EdgeInsets.zero,
                      initCropRectType: InitCropRectType.layoutRect,
                      cropAspectRatio: ImageConsts.aspectRatio,
                      maxScale: 4.0,
                      cornerColor: Colors.transparent,
                      lineColor: Colors.transparent,
                      hitTestBehavior: HitTestBehavior.deferToChild,
                    );
                  },
                ),
              ),
            ),
            if (isProcessing || isNavigating)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Future<void> _onComplete(String imagePath) async {
    final editorState = _editorKey.currentState;
    if (editorState == null) return;

    final Rect? cropRect = editorState.getCropRect();
    if (cropRect == null) return;

    final croppedImagePath = await ref
        .read(photoPreviewControllerProvider.notifier)
        .processCroppedImage(imagePath: imagePath, cropRect: cropRect);

    if (croppedImagePath != null && mounted) {
      ref.read(safeRouterProvider).goNamed(
            context,
            Routes.noonbody.name,
            extra: croppedImagePath,
          );
    }
  }
}
