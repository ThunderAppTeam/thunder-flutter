import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/constants/styles.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_button.dart';
import 'package:thunder/generated/l10n.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? content;
  final String? buttonText;
  final VoidCallback? onPressed;
  final bool isEnabled;
  const CustomBottomSheet({
    super.key,
    required this.title,
    this.subtitle,
    this.content,
    this.buttonText,
    this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    return Container(
      decoration: const BoxDecoration(
        color: ColorName.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Styles.radius24),
        ),
      ),
      child: SafeArea(
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
                Gaps.v32,
                content!,
              ],
              Gaps.v32,
              OnboardingButton(
                backgroundColor: ColorName.black,
                textColor: ColorName.white,
                text: buttonText ?? S.of(context).commonConfirm,
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
