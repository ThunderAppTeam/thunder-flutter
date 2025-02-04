import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/utils/theme_utils.dart';

class PermissionGuideTitle extends StatelessWidget {
  final String title;
  const PermissionGuideTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    return Text(
      title,
      style: textTheme.textTitle20.copyWith(
        height: Sizes.lineHeight28 / Sizes.fontSize20,
        letterSpacing: -0.2,
      ),
      textAlign: TextAlign.center,
    );
  }
}
