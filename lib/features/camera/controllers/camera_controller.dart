import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thunder/core/constants/image_consts.dart';
import 'package:thunder/core/services/permission_service.dart';
import 'package:thunder/features/camera/models/camera_state.dart';
import 'package:image/image.dart' as img;

class CameraStateNotifier extends StateNotifier<CameraState> {
  CameraStateNotifier(ref) : super(const CameraState()) {
    _permissionService = ref.read(permissionServiceProvider);
  }

  late final PermissionService _permissionService;
  CameraController? _controller;
  CameraController? _frontController;
  CameraController? _backController;
  final ImagePicker _imagePicker = ImagePicker();
  List<CameraDescription> _cameras = [];

  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  double _currentZoom = 1.0;
  double _baseScale = 1.0;

  bool _isProcessing = false;
  bool _isSwitching = false;

  CameraController get previewController => _controller!;
  double get currentZoom => _currentZoom;
  bool get isProcessing => _isProcessing;

  void _endProcessing() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _isProcessing = false;
    });
  }

  Future<void> checkPermissionAndInitialize() async {
    _isProcessing = true;
    final isGranted = await _permissionService.checkCameraPermission();
    if (isGranted) {
      state = state.copyWith(hasPermission: true);
      if (_controller == null) {
        await _initializeCamera();
      }
    }
    _endProcessing();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) throw Exception('No cameras found');
      _backController = CameraController(
        _cameras[0],
        ResolutionPreset.veryHigh,
        enableAudio: false,
      );
      if (_cameras.length > 1) {
        _frontController = CameraController(
          _cameras[1],
          ResolutionPreset.veryHigh,
          enableAudio: false,
        );
      }
      _controller = _backController;
      await _initController(_controller!);
    } catch (e) {
      state = state.copyWith(error: CameraError.initializationFailed);
    }
  }

  Future<void> _initController(CameraController controller) async {
    await controller.initialize();
    await controller.lockCaptureOrientation(DeviceOrientation.portraitUp);
    await controller.setFlashMode(state.flashMode.flashMode);
    await _initZoomLevels(controller);
    state = state.copyWith(
      isInitialized: true,
    );
  }

  // ##### --------- Camera Function --------- #####

  Future<void> switchCamera() async {
    if (_isProcessing || !state.isInitialized || _cameras.length < 2) return;
    _isProcessing = true;
    _isSwitching = true;
    final CameraLensDirection nextDirection =
        state.lensDirection == CameraLensDirection.back
            ? CameraLensDirection.front
            : CameraLensDirection.back;
    state = state.copyWith(
      lensDirection: nextDirection,
      isInitialized: false,
    );
    try {
      if (nextDirection == CameraLensDirection.back) {
        _controller = _backController;
      } else {
        _controller = _frontController;
      }
      await _initController(_controller!);
    } catch (e) {
      log('switchCamera error: $e');
      state = state.copyWith(
        error: CameraError.switchCameraFailed,
      );
    } finally {
      _isSwitching = false;
      _endProcessing();
    }
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
    if (_isProcessing || _controller == null) return;
    _isProcessing = true;
    final modes = CameraFlashMode.values;
    final currentIndex = modes.indexOf(state.flashMode);
    final nextIndex = (currentIndex + 1) % modes.length;
    try {
      await _controller!.setFlashMode(modes[nextIndex].flashMode);
      state = state.copyWith(flashMode: modes[nextIndex]);
    } catch (e) {
      state = state.copyWith(error: CameraError.flashModeChangeFailed);
    } finally {
      _endProcessing();
    }
  }

  Future<void> setFocusExposurePoint(double x, double y) async {
    if (_controller?.value.isInitialized != true) return;
    try {
      await _controller!.setFocusPoint(Offset(x, y));
      await _controller!.setExposurePoint(Offset(x, y));
    } catch (e) {
      log('setFocusPoint error: $e');
    }
  }

  Future<void> takePicture() async {
    if (_isProcessing || !state.isInitialized) return;
    _isProcessing = true;
    state = state.copyWith(isCapturing: true);
    try {
      final photo = await _controller!.takePicture();
      String imagePath = photo.path;
      if (state.lensDirection == CameraLensDirection.front) {
        final flippedFile = await flipImageHorizontally(photo.path);
        imagePath = flippedFile.path;
      }
      state = state.copyWith(selectedImagePath: imagePath);
    } catch (e) {
      state = state.copyWith(
        error: CameraError.captureError,
        isCapturing: false,
      );
    } finally {
      _endProcessing();
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
    if (_isProcessing || _isSwitching || state.isCapturing) return;
    try {
      // 이미지 피커가 무한 await, 빨리 닫았을 때 await가 끝나지 않는 이슈가 있음.
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false, // 제한된 메타데이터만 요청 권한 요청 안함
      );
      if (image == null) return;
      _isProcessing = true; // 이미지 피커의 await 에러로 인해, _isProcessing을 이미지 압축시에 사용
      final compressedFile = await _resizeAndCompressImage(image.path);
      state = state.copyWith(selectedImagePath: compressedFile!.path);
    } catch (e) {
      log('pickImage error: $e');
    } finally {
      _endProcessing();
    }
  }

  void clearSelectingImageStates() {
    state = state.copyWith(
      selectedImagePath: null,
      isCapturing: false,
    );
  }

  Future<File?> _resizeAndCompressImage(String imagePath) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      final compressed = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: ImageConsts.targetWidth,
        minHeight: ImageConsts.targetHeight,
        quality: ImageConsts.targetQuality,
      );
      await file.writeAsBytes(compressed);
      return file;
    } catch (e) {
      log('resizeAndCompressImage error: $e');
      return null;
    }
  }

  void clearSelectedImage() {
    state = state.copyWith(selectedImagePath: null);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() async {
    log('camera dispose');
    if (_controller != null) {
      await _controller!.dispose();
    }
    super.dispose();
  }
}

final cameraStateNotifierProvider =
    StateNotifierProvider.autoDispose<CameraStateNotifier, CameraState>((ref) {
  return CameraStateNotifier(ref);
});
