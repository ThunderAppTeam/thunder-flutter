import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noon_body/core/extensions/text_style.dart';
import 'package:noon_body/core/theme/constants/gaps.dart';
import 'package:noon_body/core/theme/constants/sizes.dart';
import 'package:noon_body/core/theme/constants/styles.dart';
import 'package:noon_body/core/theme/gen/colors.gen.dart';
import 'package:noon_body/core/utils/theme_utils.dart';
import 'package:noon_body/features/onboarding/views/widgets/clear_text_button.dart';

class OnboardingTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? suffixText;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onChanged;
  final TextInputType keyboardType;
  final bool autofocus;

  const OnboardingTextField({
    required this.controller,
    required this.hintText,
    this.suffixText,
    this.inputFormatters,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.autofocus = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: textTheme.textHead24,
      cursorColor: ColorName.accentBlue,
      cursorHeight: Sizes.cursorHeight28,
      autofocus: autofocus,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: textTheme.textHead24.withOpacity(Styles.opacity50),
        contentPadding: EdgeInsets.zero,
        focusedBorder: UnderlineInputBorder(
          borderSide: Styles.whiteBorder2,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: Styles.whiteBorder2,
        ),
        suffix: Padding(
          padding: const EdgeInsets.only(
            left: Sizes.spacing16,
            right: Sizes.spacing8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClearTextButton(
                isVisible: controller.text.isNotEmpty,
                onTap: () {
                  controller.clear();
                  onChanged?.call();
                },
              ),
              Gaps.h16,
              if (suffixText != null)
                Text(suffixText!, style: textTheme.textTitle16),
            ],
          ),
        ),
      ),
      onChanged: (_) => onChanged?.call(),
    );
  }
}
