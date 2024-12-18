import 'package:flutter/material.dart';
import 'package:noon_body/core/widgets/wrappers/custom_pressable_wrapper.dart';
import 'package:noon_body/core/theme/constants/sizes.dart';
import 'package:noon_body/core/theme/constants/styles.dart';
import 'package:noon_body/core/theme/gen/colors.gen.dart';
import 'package:noon_body/core/utils/theme_utils.dart';

class OnboardingSmallButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final Color backgroundColor;
  final Color textColor;

  const OnboardingSmallButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.backgroundColor = ColorName.white,
    this.textColor = ColorName.black,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPressableWrapper(
      onPressed: onPressed,
      isEnabled: isEnabled,
      child: Container(
        padding: const EdgeInsets.all(Sizes.spacing8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(Styles.radius4),
        ),
        child: Text(
          text,
          style: getTextTheme(context).textSubtitle12.copyWith(
                color: textColor.withOpacity(Styles.opacity70),
              ),
        ),
      ),
    );
  }
}
