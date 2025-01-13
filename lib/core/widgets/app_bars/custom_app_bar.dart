import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final String? title;
  final String? actionText;
  final IconData? actionIcon;
  final VoidCallback? onAction;
  final VoidCallback? onBack;

  const CustomAppBar({
    super.key,
    this.showBackButton = true,
    this.title,
    this.actionText,
    this.actionIcon,
    this.onAction,
    this.onBack,
  });

  @override
  Size get preferredSize => Size.fromHeight(Sizes.appBarHeight48);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      title: title != null
          ? Text(
              title!,
              style: getTextTheme(context).textTitle18,
            )
          : null,
      leading: showBackButton
          ? IconButton(
              iconSize: Sizes.icon32,
              icon: const Icon(Icons.chevron_left),
              onPressed: onBack ?? () => Navigator.pop(context),
            )
          : null,
      actions: [
        if (actionText != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              actionText!,
              style: getTextTheme(context).textTitle18,
            ),
          ),
        if (actionIcon != null)
          IconButton(
            onPressed: onAction,
            color: ColorName.white,
            iconSize: Sizes.icon28,
            icon: Icon(actionIcon!),
          ),
      ],
    );
  }
}
