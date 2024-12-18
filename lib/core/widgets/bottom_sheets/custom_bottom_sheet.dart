import 'package:flutter/material.dart';
import 'package:noon_body/core/theme/constants/gaps.dart';
import 'package:noon_body/core/theme/constants/sizes.dart';
import 'package:noon_body/core/theme/constants/styles.dart';
import 'package:noon_body/core/theme/gen/colors.gen.dart';
import 'package:noon_body/core/utils/theme_utils.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_button.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? content;
  final String buttonText;
  final VoidCallback? onPressed;
  final bool isEnabled;

  const CustomBottomSheet({
    super.key,
    required this.title,
    this.subtitle,
    this.content,
    required this.buttonText,
    this.onPressed,
    this.isEnabled = true,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? subtitle,
    Widget? content,
    required String buttonText,
    VoidCallback? onPressed,
    bool isEnabled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: ColorName.white,
      builder: (context) => CustomBottomSheet(
        title: title,
        subtitle: subtitle,
        content: content,
        buttonText: buttonText,
        onPressed: onPressed ?? () => Navigator.pop(context),
        isEnabled: isEnabled,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: ColorName.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Styles.radius24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: Sizes.spacing24,
            right: Sizes.spacing20,
            left: Sizes.spacing20,
            bottom: Sizes.spacing8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.textTitle20.copyWith(
                  color: ColorName.black,
                ),
              ),
              if (subtitle != null) ...[
                Gaps.v12,
                Text(
                  subtitle!,
                  style: textTheme.textBody18.copyWith(
                    color: ColorName.black,
                  ),
                ),
              ],
              if (content != null) ...[
                content!,
                Gaps.v32,
              ],
              Gaps.v32,
              OnboardingButton(
                backgroundColor: ColorName.black,
                textColor: ColorName.white,
                text: buttonText,
                onPressed: onPressed ?? () => Navigator.pop(context),
                isEnabled: isEnabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
