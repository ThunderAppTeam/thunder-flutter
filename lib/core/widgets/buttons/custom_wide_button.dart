import 'package:flutter/material.dart';
import 'package:thunder/core/widgets/wrappers/custom_pressable_wrapper.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/constants/styles.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';

class CustomWideButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final Color backgroundColor;
  final Color textColor;

  const CustomWideButton({
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
        height: Sizes.buttonHeight60,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(Styles.radius16),
        ),
        child: Center(
          child: Text(
            text,
            style: getTextTheme(context).textTitle18.copyWith(
                  color: textColor,
                ),
          ),
        ),
      ),
    );
  }
}