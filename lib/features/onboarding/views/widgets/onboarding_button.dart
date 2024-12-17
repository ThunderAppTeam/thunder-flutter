import 'package:flutter/material.dart';
import 'package:noon_body/core/animations/custom_button_animation.dart';
import 'package:noon_body/core/theme/constants/sizes.dart';
import 'package:noon_body/core/theme/constants/styles.dart';
import 'package:noon_body/core/theme/gen/colors.gen.dart';
import 'package:noon_body/core/utils/theme_utils.dart';

class OnboardingButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final Color backgroundColor;
  final Color textColor;

  const OnboardingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.backgroundColor = ColorName.white,
    this.textColor = ColorName.black,
  });

  @override
  Widget build(BuildContext context) {
    return CurstomButtonAnimation(
      onPressed: onPressed,
      isEnabled: isEnabled,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(Styles.radius16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Sizes.spacing16),
          child: Center(
            child: Text(
              text,
              style: getTextTheme(context).textTitle18.copyWith(
                    color: textColor,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
