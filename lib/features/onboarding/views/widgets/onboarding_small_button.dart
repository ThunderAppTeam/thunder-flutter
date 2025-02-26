import 'package:flutter/material.dart';
import 'package:thunder/core/widgets/wrappers/custom_pressable_wrapper.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/constants/styles.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';

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
      isEnabled: isEnabled,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Sizes.radius4),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          child: Container(
            padding: const EdgeInsets.all(Sizes.spacing8),
            child: Text(
              text,
              style: getTextTheme(context).textSubtitle12.copyWith(
                    color: textColor.withOpacity(Styles.opacity70),
                    height: Sizes.fontHeight14,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
