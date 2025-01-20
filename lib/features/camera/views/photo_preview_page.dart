import 'dart:io';

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/constants/image_consts.dart';

import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/core/widgets/custom_circular_indicator.dart';
import 'package:thunder/features/camera/controllers/photo_preview_controller.dart';
import 'package:thunder/features/body_check/view_models/body_check_view_model.dart';
import 'package:thunder/generated/l10n.dart';

class PhotoPreviewPage extends ConsumerStatefulWidget {
  final String imagePath;

  const PhotoPreviewPage({super.key, required this.imagePath});

  @override
  ConsumerState<PhotoPreviewPage> createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends ConsumerState<PhotoPreviewPage> {
  final GlobalKey<ExtendedImageEditorState> _editorKey =
      GlobalKey<ExtendedImageEditorState>();

  void _onBack() {
    ref.read(safeRouterProvider).pop(context, true); // 이미지 삭제
  }

  @override
  Widget build(BuildContext context) {
    final isProcessing = ref.watch(photoPreviewControllerProvider);
    final isNavigating = ref.watch(safeRouterProvider).isNavigating;
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).photoPreviewTitle,
          actions: [
            CustomAppBarAction(
              text: S.of(context).commonComplete,
              onTap: isProcessing || isNavigating
                  ? null
                  : () => _onComplete(widget.imagePath),
            ),
          ],
          onBack: _onBack,
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
            if (isProcessing || isNavigating) const CustomCircularIndicator(),
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
    if (croppedImagePath != null) {
      await ref.read(bodyCheckProvider.notifier).uploadImage(croppedImagePath);
      // 이미지가 업로드 완료되면 삭제.
      if (mounted) {
        ref.read(safeRouterProvider).goNamed(
              context,
              Routes.bodyCheck.name,
            );
      }
    }
  }
}
