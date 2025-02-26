import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'camera_state.freezed.dart';

enum CameraError {
  initializationFailed,
  flashModeChangeFailed,
  settingsOpenFailed,
  imagePickFailed,
  captureError,
  switchCameraFailed,
}

enum CameraFlashMode {
  auto,
  off,
  always,
}

extension CameraFlashModeX on CameraFlashMode {
  IconData get icon => switch (this) {
        CameraFlashMode.auto => Icons.flash_auto,
        CameraFlashMode.off => Icons.flash_off,
        CameraFlashMode.always => Icons.flash_on,
      };

  FlashMode get flashMode => switch (this) {
        CameraFlashMode.auto => FlashMode.auto,
        CameraFlashMode.off => FlashMode.off,
        CameraFlashMode.always => FlashMode.always,
      };
}

@freezed
class CameraState with _$CameraState {
  const factory CameraState({
    @Default(false) bool hasPermission,
    @Default(false) bool isInitialized,
    @Default(false) bool isProcessing,
    @Default(false) bool isCapturing,
    @Default(false) bool isCompressing,
    @Default(true) bool isFlashModeAvailable,
    @Default(CameraFlashMode.auto) CameraFlashMode flashMode,
    @Default(CameraLensDirection.back) CameraLensDirection lensDirection,
    String? selectedImagePath,
    CameraError? error,
  }) = _CameraState;
}
