import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thunder/core/theme/constants/styles.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:thunder/features/camera/controllers/camera_controller.dart';
import 'package:thunder/features/camera/models/camera_state.dart';
import 'package:thunder/features/camera/views/widgets/camera_app_bar.dart';
import 'package:thunder/features/camera/views/widgets/camera_bottom_controls.dart';

class CameraPage extends ConsumerStatefulWidget {
  const CameraPage({super.key});

  @override
  ConsumerState<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends ConsumerState<CameraPage> {
  late final CameraStateNotifier _controller;

  @override
  void initState() {
    super.initState();
    _controller = ref.read(cameraStateNotifierProvider.notifier);
    _controller.checkPermissionAndInitialize();
  }

  @override
  void dispose() {
    _controller.cleanUp();
    super.dispose();
  }

  void _showErrorBottomSheet(CameraError error) {
    final errorMessage = switch (error) {
      CameraError.initializationFailed => '카메라 초기화 실패',
      CameraError.flashModeChangeFailed => '플래시 모드 변경 실패',
    };
    showModalBottomSheet(
      context: context,
      builder: (context) => CustomBottomSheet(
        title: errorMessage,
      ),
    );
  }

  void _onCameraStateChanged(CameraState? prev, CameraState next) {
    if (next.error != null) {
      _showErrorBottomSheet(next.error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraStateNotifierProvider);
    ref.listen(cameraStateNotifierProvider, _onCameraStateChanged);
    return SafeArea(
      child: Scaffold(
        appBar: CameraAppBar(
          onClose: () => Navigator.pop(context),
          onFlash: () =>
              ref.read(cameraStateNotifierProvider.notifier).cycleFlashMode(),
          flashIcon: cameraState.flashMode.icon,
        ),
        body: Stack(
          children: [
            // 카메라 프리뷰 (initialized 상태에 따라)
            if (cameraState.isInitialized)
              Center(
                child: AspectRatio(
                  aspectRatio: Styles.cameraPreviewAspectRatio,
                  child: CameraPreview(_controller.controller),
                ),
              ),
            // 권한 없을 때 오버레이
            if (!cameraState.hasPermission)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('카메라 권한이 필요합니다'),
                    TextButton(
                      onPressed: () => openAppSettings(),
                      child: const Text('설정으로 이동'),
                    ),
                  ],
                ),
              ),
            // 하단 Row에 세 개 의 버튼을 배치, 갤러리, 촬영, 화면 전환
            // 카메라 권한이 없을때는 촬영, 화면 전환 버튼 비활성화
            Align(
              alignment: Alignment.bottomCenter,
              child: CameraBottomControls(
                onGalleryTap: () {
                  print('gallery');
                },
                onCaptureTap: () {
                  print('capture');
                },
                onSwitchCameraTap: () {
                  print('switch');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
