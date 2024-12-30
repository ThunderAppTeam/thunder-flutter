import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thunder/core/services/permission_service.dart';
import 'package:thunder/features/camera/models/camera_state.dart';
import 'package:image/image.dart' as img;

class CameraStateNotifier extends StateNotifier<CameraState> {
  CameraStateNotifier(ref) : super(const CameraState()) {
    _permissionService = ref.read(permissionServiceProvider);
    _imagePicker = ImagePicker();
  }

  late final PermissionService _permissionService;
  late final ImagePicker _imagePicker;
  CameraController? _controller;
  List<CameraDescription> _cameras = [];

  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  double _currentZoom = 1.0;
  double _baseScale = 1.0;

  CameraController get previewController => _controller!;
  double get currentZoom => _currentZoom;

  Future<void> checkPermissionAndInitialize() async {
    final isGranted = await _permissionService.checkCameraPermission();
    if (isGranted) {
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
      _initController(_controller!);
    } catch (e) {
      state = state.copyWith(error: CameraError.initializationFailed);
    }
  }

  Future<void> _initController(CameraController controller) async {
    await controller.initialize();
    await controller.lockCaptureOrientation(DeviceOrientation.portraitUp);
    await controller.setFocusMode(FocusMode.auto);
    await controller.setFlashMode(state.flashMode.flashMode);
    await _initZoomLevels(controller);
    state = state.copyWith(
      isInitialized: true,
    );
  }

  // ##### --------- Camera Function --------- #####

  Future<void> switchCamera() async {
    if (_cameras.length < 2) return; // 카메라가 2개 이상이 아니면 반환
    final CameraLensDirection nextDirection =
        state.lensDirection == CameraLensDirection.back
            ? CameraLensDirection.front
            : CameraLensDirection.back;
    state = state.copyWith(
      lensDirection: nextDirection,
      isInitialized: false,
      isSwitching: true,
    );
    try {
      await _controller!.dispose();
      _controller = CameraController(
        _cameras.firstWhere((camera) => camera.lensDirection == nextDirection),
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _initController(_controller!);
    } catch (e) {
      state = state.copyWith(
        error: CameraError.switchCameraFailed,
        isSwitching: false,
      );
    }
    state = state.copyWith(isSwitching: false);
  }

  /// 촬영된 이미지를 좌우 반전 후 새로운 파일로 저장
  Future<File> flipImageHorizontally(String imagePath) async {
    // 이미지 파일 읽기
    final file = File(imagePath);
    final imageBytes = await file.readAsBytes();

    // 이미지 디코딩
    final originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) {
      throw Exception("Failed to decode image.");
    }

    // 좌우 반전
    final flippedImage = img.flipHorizontal(originalImage);

    // 반전된 이미지를 새로운 파일로 저장
    final flippedImagePath = imagePath.replaceAll('.jpg', '_flipped.jpg');
    final flippedFile = File(flippedImagePath);

    await flippedFile.writeAsBytes(img.encodeJpg(flippedImage));

    return flippedFile;
  }

  Future<void> _initZoomLevels(CameraController controller) async {
    _minZoom = await controller.getMinZoomLevel();
    _maxZoom = await controller.getMaxZoomLevel();
    _currentZoom = _minZoom;
    await controller.setZoomLevel(_currentZoom);
  }

  void onScaleStart() {
    _baseScale = _currentZoom;
  }

  Future<void> setZoomLevel(double scale) async {
    if (_controller?.value.isInitialized != true) return;

    try {
      _currentZoom = (_baseScale * scale).clamp(_minZoom, _maxZoom);
      await _controller!.setZoomLevel(_currentZoom);
    } catch (e) {
      log('setZoomLevel error: $e');
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

  Future<void> takePicture() async {
    if (_controller?.value.isInitialized != true) return;
    try {
      state = state.copyWith(isCapturing: true);
      final photo = await _controller!.takePicture();

      String imagePath = photo.path;

      if (state.lensDirection == CameraLensDirection.front) {
        final flippedFile = await flipImageHorizontally(photo.path);
        imagePath = flippedFile.path;
      }

      state = state.copyWith(
        isCapturing: false,
        selectedImagePath: imagePath,
      );
    } catch (e) {
      state =
          state.copyWith(error: CameraError.captureError, isCapturing: false);
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

  Future<void> pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false, // 제한된 메타데이터만 요청 권한 요청 안함
      );
      if (image != null) {
        state = state.copyWith(selectedImagePath: image.path);
      }
    } catch (e) {
      state = state.copyWith(error: CameraError.imagePickFailed);
    }
  }

  void clearSelectedImage() {
    state = state.copyWith(selectedImagePath: null);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> cleanUp() async {
    if (_controller != null) {
      await _controller!.dispose();
      _controller = null;
      state = state.copyWith(
        isInitialized: false,
        error: null,
        selectedImagePath: null,
      );
    }
  }

  @override
  void dispose() {
    cleanUp();
    super.dispose();
  }
}

final cameraStateNotifierProvider =
    StateNotifierProvider<CameraStateNotifier, CameraState>((ref) {
  return CameraStateNotifier(ref);
});
