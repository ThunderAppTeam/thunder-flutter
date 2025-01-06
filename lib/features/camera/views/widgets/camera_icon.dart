import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';

class CameraIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  /// 상단바에서 사용되는 아이콘
  const CameraIcon({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Icon(
        icon,
        size: Sizes.icon28,
        color: ColorName.white,
      ),
    );
  }
}
