import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/constants/styles.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';
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
      CameraError.settingsOpenFailed => '카메라 접근 권한 설정 실패',
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
    final textTheme = getTextTheme(context);
    return SafeArea(
      child: Scaffold(
        appBar: CameraAppBar(
          onClose: () => Navigator.pop(context),
          onFlash: () =>
              ref.read(cameraStateNotifierProvider.notifier).cycleFlashMode(),
          flashIcon: cameraState.flashMode.icon,
          hasPermission: cameraState.hasPermission,
        ),
        body: Stack(
          children: [
            if (cameraState.isInitialized)
              Center(
                child: AspectRatio(
                  aspectRatio: Styles.cameraPreviewAspectRatio,
                  child: CameraPreview(_controller.controller),
                ),
              ),
            Column(
              children: [
                Expanded(
                  // 권한 없을 때 오버레이
                  child: !cameraState.hasPermission
                      ? Container(
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
                                    onPressed: () =>
                                        _controller.openPermissionSettings(),
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
                        )
                      : const SizedBox(),
                ),
                // 하단 Row에 세 개 의 버튼을 배치, 갤러리, 촬영, 화면 전환
                CameraBottomControls(
                  hasPermission: cameraState.hasPermission,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
