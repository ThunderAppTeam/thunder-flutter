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
  final FocusNode? focusNode;
  final String hintText;
  final String? suffixText;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final bool autofocus;
  final bool canClear;

  const OnboardingTextField({
    required this.controller,
    this.focusNode,
    required this.hintText,
    this.suffixText,
    this.inputFormatters,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.autofocus = false,
    this.canClear = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    final hasSuffix = canClear || suffixText != null;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: textTheme.textHead24,
      cursorColor: ColorName.accentBlue,
      cursorHeight: Sizes.cursorHeight28,
      autofocus: autofocus,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: textTheme.textHead24.withOpacity(Styles.opacity50),
        isDense: true,
        contentPadding: const EdgeInsets.all(Sizes.spacing8),
        focusedBorder: UnderlineInputBorder(
          borderSide: Styles.whiteBorder2,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: Styles.whiteBorder2,
        ),
        suffix: hasSuffix
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (canClear) ...[
                    Gaps.h16,
                    ClearTextButton(
                      isVisible: controller.text.isNotEmpty,
                      onTap: () {
                        controller.clear();
                        onChanged?.call(controller.text);
                      },
                    ),
                  ],
                  if (suffixText != null) ...[
                    Gaps.h16,
                    Text(suffixText!, style: textTheme.textTitle16),
                  ],
                ],
              )
            : null,
      ),
      onChanged: onChanged,
    );
  }
}
