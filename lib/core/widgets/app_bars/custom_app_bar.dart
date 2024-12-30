import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/utils/theme_utils.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final String? title;
  final String? actionText;
  final VoidCallback? onAction;

  const CustomAppBar({
    super.key,
    this.showBackButton = true,
    this.title,
    this.actionText,
    this.onAction,
  });

  @override
  Size get preferredSize => Size.fromHeight(Sizes.appBarHeight48);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
              onPressed: () => Navigator.pop(context),
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
      ],
    );
  }
}
