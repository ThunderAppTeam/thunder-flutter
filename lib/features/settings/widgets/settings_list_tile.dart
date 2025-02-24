import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/features/settings/widgets/settings_trailing.dart';
export 'settings_trailing.dart';

class SettingsListTile extends StatelessWidget {
  final IconData? icon;
  final String title;

  final bool isGray;
  final VoidCallback? onTap;
  final SettingsTrailing? trailing;

  const SettingsListTile({
    super.key,
    this.icon,
    required this.title,
    this.isGray = false,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: Sizes.spacing16),
      onTap: onTap,
      horizontalTitleGap: Sizes.spacing12,
      leading: icon != null
          ? Icon(
              icon,
              size: Sizes.icon28,
              color: ColorName.white,
            )
          : null,
      title: Text(
        title,
        style: textTheme.textBody18.copyWith(
          color: isGray ? ColorName.darkLabel2 : ColorName.white,
        ),
      ),
      trailing: trailing,
    );
  }
}
