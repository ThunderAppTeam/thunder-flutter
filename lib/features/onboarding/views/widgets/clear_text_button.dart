import 'package:flutter/material.dart';
import 'package:noon_body/core/theme/constants/sizes.dart';
import 'package:noon_body/core/theme/constants/styles.dart';
import 'package:noon_body/core/theme/gen/colors.gen.dart';

class ClearTextButton extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onTap;

  const ClearTextButton({
    required this.isVisible,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Styles.duration200,
      opacity: isVisible ? Styles.opacity100 : Styles.opacity0,
      child: AnimatedScale(
        duration: Styles.duration100,
        scale: isVisible ? Styles.scale100 : Styles.scale0,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(Sizes.spacing4),
            decoration: BoxDecoration(
              color: ColorName.white.withOpacity(Styles.opacity90),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.clear,
              color: ColorName.black,
              size: Sizes.icon14,
            ),
          ),
        ),
      ),
    );
  }
}
