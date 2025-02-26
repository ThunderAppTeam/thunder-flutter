import 'dart:io';

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/constants/image_const.dart';
import 'package:thunder/core/constants/key_contst.dart';
import 'package:thunder/core/errors/server_error.dart';
import 'package:thunder/core/utils/show_utils.dart';

import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/core/widgets/custom_circular_indicator.dart';
import 'package:thunder/features/archive/view_models/archive_view_model.dart';
import 'package:thunder/features/photo/view_models/photo_preview_view_model.dart';
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
  bool _isProcessing = false;

  late final PhotoPreviewViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(photoPreviewProvider.notifier);
  }

  void _onBack() {
    ref.read(safeRouterProvider).pop(context); // 이미지 삭제
  }

  Future<void> _onComplete(String imagePath) async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
    });
    try {
      final editorState = _editorKey.currentState;
      if (editorState == null) return;

      final Rect? cropRect = editorState.getCropRect();
      if (cropRect == null) return;

      final imageData = await _viewModel.cropAndUploadImage(
        imagePath: imagePath,
        cropRect: cropRect,
      );
      if (imageData == null) return;
      if (mounted) {
        ref.read(archiveViewModelProvider.notifier).refresh();
        ref.read(safeRouterProvider).goToArchive(context, skip: true);
        ref.read(safeRouterProvider).pushNamed(
          context,
          Routes.bodyCheck.name,
          pathParameters: {
            KeyConst.bodyPhotoId: imageData.bodyPhotoId.toString(),
          },
          extra: {
            KeyConst.fromUpload: true,
            KeyConst.imageUrl: imageData.imageUrl,
          },
        );
      }
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNavigating = ref.watch(safeRouterStateProvider);
    ref.listen(
      photoPreviewProvider,
      (prev, next) {
        if (!next.isLoading && next.hasError) {
          if (next.error == ServerError.bodyNotDetectedInPhoto) {
            showCustomBottomSheet(
              context,
              title: S.of(context).photoPreviewBodyNotDetectedErrorTitle,
              subtitle: S.of(context).photoPreviewBodyNotDetectedErrorSubtitle,
            );
          } else {
            showCommonUnknownErrorBottomSheet(context);
          }
        }
      },
    );
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).photoPreviewTitle,
          actions: [
            CustomAppBarAction(
              type: _isProcessing || isNavigating
                  ? CustomAppBarActionType.child
                  : CustomAppBarActionType.text,
              child: CustomCircularIndicator(),
              text: S.of(context).commonComplete,
              onTap: () => _isProcessing || isNavigating
                  ? null
                  : _onComplete(widget.imagePath),
            ),
          ],
          onBack: _onBack,
        ),
        body: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: ImageConst.aspectRatio,
                child: ExtendedImage.file(
                  File(widget.imagePath),
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.editor,
                  extendedImageEditorKey: _editorKey,
                  initEditorConfigHandler: (state) {
                    return EditorConfig(
                      cropRectPadding: EdgeInsets.zero,
                      initCropRectType: InitCropRectType.layoutRect,
                      cropAspectRatio: ImageConst.aspectRatio,
                      maxScale: 4.0,
                      cornerColor: Colors.transparent,
                      lineColor: Colors.transparent,
                      hitTestBehavior: HitTestBehavior.deferToChild,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
