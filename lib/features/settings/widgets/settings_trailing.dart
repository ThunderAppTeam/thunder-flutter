import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/features/settings/widgets/settings_switch.dart';

class SettingsTrailing extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final bool? toggleValue;
  final void Function(bool)? toggleOnChanged;

  const SettingsTrailing.text(
    this.text, {
    super.key,
  })  : icon = null,
        toggleValue = null,
        toggleOnChanged = null;

  const SettingsTrailing.icon(
    this.icon, {
    super.key,
  })  : text = null,
        toggleValue = null,
        toggleOnChanged = null;

  const SettingsTrailing.toggle({
    required this.toggleValue,
    required this.toggleOnChanged,
    super.key,
  })  : text = null,
        icon = null;

  @override
  Widget build(BuildContext context) {
    if (text != null) {
      final textTheme = getTextTheme(context);
      return Text(
        text!,
        style: textTheme.textBody18.copyWith(
          color: ColorName.white,
        ),
      );
    }

    if (toggleValue != null && toggleOnChanged != null) {
      return SettingsSwitch(
        value: toggleValue!,
        onChanged: toggleOnChanged!,
      );
    }

    return Icon(
      icon,
      size: Sizes.icon24,
      color: ColorName.white,
    );
  }
}
