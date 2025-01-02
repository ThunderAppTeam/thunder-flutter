import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/assets.gen.dart';
import 'package:thunder/features/camera/views/widgets/camera_button.dart';
import 'package:thunder/features/camera/views/widgets/ios_style_capture_button.dart';

class CameraBottomControls extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCaptureTap;
  final VoidCallback onSwitchCameraTap;
  final bool hasPermission;
  final bool buttonsEnabled;

  const CameraBottomControls({
    super.key,
    required this.onGalleryTap,
    required this.onCaptureTap,
    required this.onSwitchCameraTap,
    required this.hasPermission,
    required this.buttonsEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.spacing16,
        vertical: Sizes.spacing32,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CameraButton(
            onTap: buttonsEnabled ? onGalleryTap : null,
            child: Assets.images.camera.galleryButton.svg(),
          ),
          IOSStyleCaptureButton(
            onTap: buttonsEnabled ? onCaptureTap : null,
            isEnabled: hasPermission,
          ),
          CameraButton(
            onTap: buttonsEnabled ? onSwitchCameraTap : null,
            isEnabled: hasPermission,
            child: Assets.images.camera.cameraReverseButton.svg(),
          ),
        ],
      ),
    );
  }
}
