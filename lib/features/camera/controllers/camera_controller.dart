import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thunder/core/services/permission_service.dart';
import 'package:thunder/features/camera/models/camera_state.dart';

class CameraStateNotifier extends StateNotifier<CameraState> {
  CameraStateNotifier(this._permissionService) : super(const CameraState());

  final PermissionService _permissionService;
  CameraController? _controller;
  List<CameraDescription> _cameras = [];

  CameraController get controller => _controller!;

  Future<void> checkPermissionAndInitialize() async {
    final isGranted = await _permissionService.checkCameraPermission();
    if (!isGranted) {
      state = state.copyWith(hasPermission: true);
      if (_controller == null) {
        await _initializeCamera();
      }
    }
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isEmpty) return;
    _controller = CameraController(
      _cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );
    try {
      await _controller!.initialize();
      await _controller!.lockCaptureOrientation(DeviceOrientation.portraitUp);
      state = state.copyWith(
        isInitialized: true,
      );
    } catch (e) {
      state = state.copyWith(error: CameraError.initializationFailed);
    }
  }

  Future<void> cycleFlashMode() async {
    if (_controller == null) return;
    final modes = CameraFlashMode.values;
    final currentIndex = modes.indexOf(state.flashMode);
    final nextIndex = (currentIndex + 1) % modes.length;
    try {
      await _controller!.setFlashMode(modes[nextIndex].flashMode);
      state = state.copyWith(flashMode: modes[nextIndex]);
    } catch (e) {
      state = state.copyWith(error: CameraError.flashModeChangeFailed);
    }
  }

  Future<void> openPermissionSettings() async {
    try {
      final isOpened = await openAppSettings();
      if (!isOpened) {
        throw Exception('Failed to open permission settings');
      }
    } catch (e) {
      state = state.copyWith(
        error: CameraError.settingsOpenFailed,
      );
    }
  }

  @override
  void dispose() {
    cleanUp();
    super.dispose();
  }

  Future<void> cleanUp() async {
    if (_controller != null) {
      await _controller!.dispose();
      _controller = null;
      state = state.copyWith(isInitialized: false, error: null);
    }
  }
}

final cameraStateNotifierProvider =
    StateNotifierProvider<CameraStateNotifier, CameraState>((ref) {
  return CameraStateNotifier(ref.read(permissionServiceProvider));
});
