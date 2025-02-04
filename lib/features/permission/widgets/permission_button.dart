import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';

enum ClipDirection {
  bottomLeft,
  bottomRight,
}

class PermissionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isAllow;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;

  const PermissionButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.isAllow,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    final buttonHeight = 44.0;
    return Material(
      clipBehavior: Clip.hardEdge,
      color: isAllow ? ColorName.iosBlue : Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: buttonHeight,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: border,
          ),
          child: Center(
            child: Text(
              text,
              style: textTheme.customStyle.copyWith(
                fontSize: 17,
                height: Sizes.lineHeight22 / 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
