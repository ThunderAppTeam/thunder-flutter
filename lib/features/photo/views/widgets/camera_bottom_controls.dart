import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/assets.gen.dart';
import 'package:thunder/features/photo/views/widgets/camera_button.dart';
import 'package:thunder/features/photo/views/widgets/ios_style_capture_button.dart';

class CameraBottomControls extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCaptureTap;
  final VoidCallback onSwitchCameraTap;
  final bool hasPermission;

  const CameraBottomControls({
    super.key,
    required this.onGalleryTap,
    required this.onCaptureTap,
    required this.onSwitchCameraTap,
    required this.hasPermission,
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
            onTap: onGalleryTap,
            child: Assets.images.camera.galleryButton.svg(),
          ),
          IOSStyleCaptureButton(
            onTap: onCaptureTap,
            isEnabled: hasPermission,
          ),
          CameraButton(
            onTap: onSwitchCameraTap,
            isEnabled: hasPermission,
            child: Assets.images.camera.cameraReverseButton.svg(),
          ),
        ],
      ),
    );
  }
}
