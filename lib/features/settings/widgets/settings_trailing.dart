import 'package:flutter/widgets.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';

class SettingsTrailing extends StatelessWidget {
  final String? text;
  final IconData? icon;

  const SettingsTrailing.text(
    this.text, {
    super.key,
  }) : icon = null;

  const SettingsTrailing.icon(
    this.icon, {
    super.key,
  }) : text = null;

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);

    if (text != null) {
      return Text(
        text!,
        style: textTheme.textBody18.copyWith(
          color: ColorName.white,
        ),
      );
    }

    return Icon(
      icon,
      size: Sizes.icon24,
      color: ColorName.white,
    );
  }
}
