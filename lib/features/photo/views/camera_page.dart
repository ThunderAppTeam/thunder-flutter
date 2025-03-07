import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/constants/image_const.dart';
import 'package:thunder/core/constants/time_const.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/show_utils.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/custom_circular_indicator.dart';
import 'package:thunder/features/photo/controllers/camera_controller.dart';
import 'package:thunder/features/photo/models/camera_state.dart';
import 'package:thunder/features/photo/views/widgets/camera_app_bar.dart';
import 'package:thunder/features/photo/views/widgets/camera_bottom_controls.dart';
import 'package:thunder/generated/l10n.dart';

class CameraPage extends ConsumerStatefulWidget {
  const CameraPage({super.key});

  @override
  ConsumerState<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends ConsumerState<CameraPage>
    with SingleTickerProviderStateMixin {
  late final CameraStateNotifier _controller;
  late final AnimationController _shutterController;

  @override
  void initState() {
    super.initState();
    _controller = ref.read(cameraStateNotifierProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.checkPermissionAndInitialize();
    });
    _shutterController = AnimationController(
      duration: TimeConst.cameraFlashDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _shutterController.dispose();
    super.dispose();
  }

  void _showErrorBottomSheet(CameraError error) {
    showCommonUnknownErrorBottomSheet(context);
  }

  Future<void> _onFocusTap(
    TapUpDetails details,
    BuildContext context,
    WidgetRef ref,
  ) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPoint = box.globalToLocal(details.globalPosition);

    // 프리뷰 크기를 기준으로 상대 좌표 계산
    final double x = localPoint.dx / box.size.width;
    final double y = localPoint.dy / box.size.height;

    await _controller.setFocusExposurePoint(x, y);
  }

  void _onCameraStateChanged(CameraState? prev, CameraState next) async {
    if (prev?.error == null && next.error != null) {
      // 에러가 발생했을 때
      _showErrorBottomSheet(next.error!);
    }

    if (next.isCapturing != prev?.isCapturing) {
      // 깜빡이는 애니메이션 실행
      _shutterController.forward().then((_) {
        _shutterController.reverse();
      });
    }

    // 새로운 이미지가 선택되었을 때 미리보기 페이지로 이동
    if (prev?.selectedImagePath == null && next.selectedImagePath != null) {
      if (mounted) {
        await context.pushNamed(
          Routes.photoPreview.name,
          extra: next.selectedImagePath,
        );
        // 미리보기 화면에서 돌아왔을 시, 업로드 완료 후 Context.pop되었을 때, 이미지 삭제
        await _controller.clearSelectedImageStates();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraStateNotifierProvider);
    ref.listen(cameraStateNotifierProvider, _onCameraStateChanged);
    return SafeArea(
      child: Scaffold(
        appBar: CameraAppBar(
          onClose: () async {
            if (cameraState.isProcessing) return;
            // 카메라가 초기화 에러가 아닐 때, 초기화가 안되있으면 뒤로가기 방지
            ref.read(safeRouterProvider).pop(context);
          },
          isFlashModeAvailable: cameraState.isFlashModeAvailable,
          onFlash: () => _controller.cycleFlashMode(),
          flashIcon: cameraState.flashMode.icon,
          hasPermission: cameraState.hasPermission,
        ),
        body: Center(
          child: AspectRatio(
            aspectRatio: ImageConst.aspectRatio,
            child: Stack(
              children: [
                if (cameraState.isCompressing)
                  Center(child: CustomCircularIndicator()),
                if (cameraState.isInitialized && cameraState.hasPermission)
                  GestureDetector(
                    onTapUp: (details) => _onFocusTap(details, context, ref),
                    onScaleStart: (_) => _controller.onScaleStart(),
                    onScaleUpdate: (details) =>
                        _controller.setZoomLevel(details.scale),
                    child: AspectRatio(
                      aspectRatio: ImageConst.aspectRatio,
                      child: Stack(
                        children: [
                          CameraPreview(_controller.previewController),
                          // 촬영 시에 깜빡이는 애니메이션
                          FadeTransition(
                            opacity: _shutterController,
                            child: Container(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                Column(
                  children: [
                    Expanded(
                      child: !cameraState.hasPermission
                          ? _buildPermissionDeniedView()
                          : const SizedBox(),
                    ),
                    CameraBottomControls(
                      hasPermission: cameraState.hasPermission,
                      onGalleryTap: () => _controller.pickImage(),
                      onCaptureTap: () => _controller.takePicture(),
                      onSwitchCameraTap: () => _controller.switchCamera(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionDeniedView() {
    final textTheme = getTextTheme(context);
    return Container(
      color: ColorName.darkBackground2,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.spacing16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).cameraPermissionGuideText,
                style: textTheme.textTitle20.copyWith(
                  height: Sizes.fontHeight14,
                ),
                textAlign: TextAlign.center,
              ),
              Gaps.v32,
              TextButton(
                onPressed: () => _controller.openPermissionSettings(),
                child: Text(
                  S.of(context).cameraPermissionAllow,
                  style: textTheme.textTitle20.copyWith(
                    color: ColorName.iosBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
