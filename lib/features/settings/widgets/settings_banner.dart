import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';

class SettingsBanner extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onButtonTap;
  const SettingsBanner({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    return Material(
      color: ColorName.white,
      child: InkWell(
        onTap: onButtonTap,
        child: Padding(
          padding: EdgeInsets.all(Sizes.spacing16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.textSubtitle14.copyWith(
                      fontWeight: FontWeight.w700,
                      color: ColorName.black.withOpacity(0.8),
                    ),
                  ),
                  Gaps.v8,
                  Text(
                    description,
                    style: textTheme.textBody12.copyWith(
                      color: ColorName.black.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              Text(
                buttonText,
                style: textTheme.textBody12.copyWith(color: ColorName.iosBlue),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
