import 'package:flutter/material.dart';
import 'package:noon_body/core/theme/constants/gaps.dart';
import 'package:noon_body/core/theme/constants/sizes.dart';
import 'package:noon_body/core/theme/constants/styles.dart';
import 'package:noon_body/core/theme/gen/colors.gen.dart';
import 'package:noon_body/core/utils/theme_utils.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_button.dart';

class CustomAlertBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;

  const CustomAlertBottomSheet({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = '확인',
    this.onPressed,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = '확인',
    VoidCallback? onPressed,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: ColorName.white,
      builder: (context) => CustomAlertBottomSheet(
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed ?? () => Navigator.pop(context),
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
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.textTitle20.copyWith(
                      color: ColorName.black,
                    ),
                  ),
                  Gaps.v12,
                  Text(
                    message,
                    style: textTheme.textBody18.copyWith(
                      color: ColorName.black,
                    ),
                  ),
                ],
              ),
              Gaps.v32,
              OnboardingButton(
                backgroundColor: ColorName.black,
                textColor: ColorName.white,
                text: buttonText,
                onPressed: onPressed ?? () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
