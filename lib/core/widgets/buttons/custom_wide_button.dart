import 'package:flutter/material.dart';
import 'package:thunder/core/widgets/wrappers/custom_pressable_wrapper.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
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
      isEnabled: isEnabled,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Sizes.radius16),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          child: SizedBox(
            height: Sizes.buttonHeight60,
            child: Center(
              child: Text(
                text,
                style:
                    getTextTheme(context).textBody18.copyWith(color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
