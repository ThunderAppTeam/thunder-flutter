import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String confirmText;
  final String cancelText;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.confirmText,
    required this.cancelText,
  });

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required bool isConfirm,
    required VoidCallback onTap,
  }) {
    return Material(
      color: ColorName.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: Sizes.spacing16,
            horizontal: Sizes.spacing20,
          ),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 0.33,
                color: ColorName.alertGrayLight.withOpacity(0.55),
              ),
            ),
          ),
          child: Text(
            text,
            style: getTextTheme(context).textTitle18.copyWith(
                  color: isConfirm ? ColorName.alertRed : ColorName.black,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.radius14),
      ),
      clipBehavior: Clip.hardEdge,
      child: Container(
        width: Sizes.dialogWidth280,
        color: ColorName.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: Sizes.spacing28,
                left: Sizes.spacing20,
                right: Sizes.spacing20,
                bottom: Sizes.spacing20,
              ),
              child: Column(
                children: [
                  Text(
                    title,
                    style: textTheme.textTitle18.copyWith(
                      color: ColorName.black,
                      height: Sizes.lineHeight22 / Sizes.fontSize18,
                    ),
                  ),
                  Gaps.v12,
                  Text(
                    subtitle,
                    style: textTheme.textSubtitle14.copyWith(
                      color: ColorName.alertGray,
                      fontWeight: FontWeight.w500,
                      height: Sizes.lineHeight18 / Sizes.fontSize14,
                      letterSpacing: -0.08,
                    ),
                  ),
                ],
              ),
            ),
            Gaps.v2,
            _buildButton(
              context: context,
              text: confirmText,
              isConfirm: true,
              onTap: () => Navigator.pop(context, true),
            ),
            _buildButton(
              context: context,
              text: cancelText,
              isConfirm: false,
              onTap: () => Navigator.pop(context, false),
            ),
          ],
        ),
      ),
    );
  }
}
