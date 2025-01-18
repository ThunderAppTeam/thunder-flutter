import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thunder/core/constants/image_consts.dart';
import 'package:thunder/core/services/cache_service.dart';
import 'package:thunder/core/services/permission_service.dart';
import 'package:thunder/core/utils/image_utils.dart';
import 'package:thunder/features/camera/models/camera_state.dart';
import 'package:image/image.dart' as img;

class CameraStateNotifier extends StateNotifier<CameraState> {
  CameraStateNotifier(ref) : super(const CameraState());
  CameraController? _controller;
  CameraController? _frontController;
  CameraController? _backController;
  final ImagePicker _imagePicker = ImagePicker();
  List<CameraDescription> _cameras = [];

  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  double _currentZoom = 1.0;
  double _baseScale = 1.0;

  CameraController get previewController => _controller!;
  double get currentZoom => _currentZoom;

  void _endProcessing({int delay = 500}) {
    Future.delayed(Duration(milliseconds: delay), () {
      state = state.copyWith(isProcessing: false);
    });
  }

  Future<void> checkPermissionAndInitialize() async {
    if (state.isProcessing) return;
    state = state.copyWith(isProcessing: true);
    final isGranted = await PermissionService.checkCameraPermission();
    if (isGranted) {
      state = state.copyWith(hasPermission: true);
      if (_controller == null) {
        await _initializeCamera();
      }
    }
    _endProcessing(delay: 500);
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
    state = state.copyWith(isInitialized: true);
  }

  // ##### --------- Camera Function --------- #####

  Future<void> switchCamera() async {
    if (state.isProcessing) return;
    state = state.copyWith(isProcessing: true);
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
      _endProcessing(delay: 200);
    }
  }

  /// 촬영된 이미지를 좌우 반전
  Future<void> _flipImageHorizontally(String imagePath) async {
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
    await file.writeAsBytes(img.encodeJpg(flippedImage));
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
    if (state.isProcessing || !state.isInitialized) return;
    state = state.copyWith(isProcessing: true);
    try {
      _currentZoom = (_baseScale * scale).clamp(_minZoom, _maxZoom);
      await _controller!.setZoomLevel(_currentZoom);
    } catch (e) {
      log('setZoomLevel error: $e');
    } finally {
      state = state.copyWith(isProcessing: false);
    }
  }

  Future<void> cycleFlashMode() async {
    if (state.isProcessing || !state.isInitialized) return;
    state = state.copyWith(isProcessing: true);
    final modes = CameraFlashMode.values;
    final currentIndex = modes.indexOf(state.flashMode);
    final nextIndex = (currentIndex + 1) % modes.length;
    try {
      await _controller!.setFlashMode(modes[nextIndex].flashMode);
      state = state.copyWith(flashMode: modes[nextIndex]);
    } catch (e) {
      state = state.copyWith(error: CameraError.flashModeChangeFailed);
    } finally {
      state = state.copyWith(isProcessing: false);
    }
  }

  Future<void> setFocusExposurePoint(double x, double y) async {
    if (state.isProcessing || !state.isInitialized) return;
    state = state.copyWith(isProcessing: true);
    try {
      await _controller!.setFocusPoint(Offset(x, y));
      await _controller!.setExposurePoint(Offset(x, y));
    } catch (e) {
      log('setFocusPoint error: $e');
    } finally {
      state = state.copyWith(isProcessing: false);
    }
  }

  Future<void> takePicture() async {
    if (state.isProcessing || !state.isInitialized) return;
    state = state.copyWith(isProcessing: true, isCapturing: true);
    try {
      final photo = await _controller!.takePicture();
      final newPath = await CacheService.getNewImagePath();
      final newFile = await File(photo.path).rename(newPath);

      if (state.lensDirection == CameraLensDirection.front) {
        await _flipImageHorizontally(newFile.path);
      }
      state = state.copyWith(selectedImagePath: newFile.path);
    } catch (e) {
      state = state.copyWith(
        error: CameraError.captureError,
        isCapturing: false,
      );
    } finally {
      _endProcessing(delay: 200);
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
    if (state.isProcessing) return;
    try {
      // 이미지 피커가 무한 await, 빨리 닫았을 때 await가 끝나지 않는 이슈가 있음.
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false, // 제한된 메타데이터만 요청 권한 요청 안함
      );
      if (image == null) return;
      state = state.copyWith(isCompressing: true, isProcessing: true);
      // 새로운 경로로 이동
      final newImagePath = await CacheService.getNewImagePath();
      final newFile = await File(image.path).rename(newImagePath);
      // 상위 폴더 정리 (안드로이드만 처리, 폴더가 생기는 문제)
      if (Platform.isAndroid) {
        clearFolder(File(image.path).parent);
      }
      final compressedFile = await _resizeAndCompressImage(newFile.path);
      state = state.copyWith(
        selectedImagePath: compressedFile!.path,
        isCompressing: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: CameraError.imagePickFailed,
        isCompressing: false,
      );
    } finally {
      _endProcessing();
    }
  }

  Future<void> clearSelectedImageStates() async {
    try {
      await clearImage(state.selectedImagePath!);
      log('Image deleted: ${state.selectedImagePath!}');
    } catch (e) {
      log('Failed to delete image: $e');
    }
    state = state.copyWith(
      selectedImagePath: null,
      isCapturing: false,
    );
  }

  Future<File?> _resizeAndCompressImage(String imagePath) async {
    final file = File(imagePath);
    final bytes = await file.readAsBytes();

    // 해상도 줄이기
    final compressed = await FlutterImageCompress.compressWithList(
      bytes,
      minWidth: ImageConsts.targetWidth,
      minHeight: ImageConsts.targetHeight,
      format: CompressFormat.jpeg,
      quality: 100,
    );

    final compressedFile = File(
        '${file.parent.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await compressedFile.writeAsBytes(compressed);
    await file.delete();
    return compressedFile;
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
