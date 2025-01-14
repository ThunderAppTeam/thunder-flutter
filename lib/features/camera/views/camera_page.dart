import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/constants/image_consts.dart';
import 'package:thunder/core/constants/time_consts.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:thunder/core/widgets/custom_circular_indicator.dart';
import 'package:thunder/features/camera/controllers/camera_controller.dart';
import 'package:thunder/features/camera/models/camera_state.dart';
import 'package:thunder/features/camera/views/photo_preview_page.dart';
import 'package:thunder/features/camera/views/widgets/camera_app_bar.dart';
import 'package:thunder/features/camera/views/widgets/camera_bottom_controls.dart';

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
    _controller.checkPermissionAndInitialize();
    _shutterController = AnimationController(
      duration: TimeConsts.cameraFlashDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _shutterController.dispose();
    super.dispose();
  }

  void _showErrorBottomSheet(CameraError error) {
    final errorMessage = switch (error) {
      CameraError.initializationFailed => '카메라 초기화 도중 오류가 발생했습니다',
      CameraError.flashModeChangeFailed => '플래시 모드 변경 도중 오류가 발생했습니다',
      CameraError.settingsOpenFailed => '카메라 접근 권한 설정 실패',
      CameraError.imagePickFailed => '이미지 선택 도중 오류가 발생했습니다',
      CameraError.captureError => '사진 촬영 도중 오류가 발생했습니다',
      CameraError.switchCameraFailed => '카메라 전환 도중 오류가 발생했습니다',
    };
    showModalBottomSheet(
      context: context,
      builder: (context) => CustomBottomSheet(
        title: errorMessage,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
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
      // 새로운 이
      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoPreviewPage(
              imagePath: next.selectedImagePath!,
            ),
          ),
        );
        _controller.clearSelectingImageStates();
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
            if (!cameraState.isInitialized &&
                cameraState.error != CameraError.initializationFailed) {
              // 카메라가 초기화 에러가 아닐 때, 초기화가 안되있으면 뒤로가기 방지
              return;
            }
            ref.read(safeRouterProvider).pop(context);
          },
          onFlash: () => _controller.cycleFlashMode(),
          flashIcon: cameraState.flashMode.icon,
          hasPermission: cameraState.hasPermission,
        ),
        body: Center(
          child: AspectRatio(
            aspectRatio: ImageConsts.aspectRatio,
            child: Stack(
              children: [
                if (cameraState.isCompressing) const CustomCircularIndicator(),
                if (cameraState.isInitialized && cameraState.hasPermission)
                  GestureDetector(
                    onTapUp: (details) => _onFocusTap(details, context, ref),
                    onScaleStart: (_) => _controller.onScaleStart(),
                    onScaleUpdate: (details) =>
                        _controller.setZoomLevel(details.scale),
                    child: AspectRatio(
                      aspectRatio: ImageConsts.aspectRatio,
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
      color: ColorName.iosDarkGray,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.spacing16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Thunder 앱에서 사진을 촬영하기 위해\n카메라 접근 권한을 허용해주세요',
                style: textTheme.textTitle20,
                textAlign: TextAlign.center,
              ),
              Gaps.v32,
              TextButton(
                onPressed: () => _controller.openPermissionSettings(),
                child: Text(
                  '카메라 접근 권한 허용하기',
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
