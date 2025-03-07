import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/theme/icon/thunder_icons_icons.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/buttons/custom_icon_button.dart';

enum CustomAppBarActionType {
  text,
  icon,
  child,
}

class CustomAppBarAction {
  final CustomAppBarActionType type;
  final String? text;
  final IconData? icon;
  final VoidCallback? onTap;
  final Widget? child;

  CustomAppBarAction({
    required this.type,
    this.text,
    this.icon,
    this.child,
    this.onTap,
  });
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final Widget? leading;
  final String? title;
  final List<CustomAppBarAction>? actions;
  final VoidCallback? onBack;

  const CustomAppBar({
    super.key,
    this.showBackButton = true,
    this.leading,
    this.title,
    this.actions,
    this.onBack,
  });

  @override
  Size get preferredSize => Size.fromHeight(Sizes.appBarHeight48);

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    return AppBar(
      toolbarHeight: preferredSize.height,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.spacing8),
        height: preferredSize.height,
        child: Stack(
          children: [
            // (1) Center Title
            if (title != null)
              Center(
                child: Text(
                  title!,
                  style: textTheme.textTitle18,
                ),
              ),

            // (2) Leading (예: 뒤로가기 버튼)
            if (showBackButton)
              Align(
                alignment: Alignment.centerLeft,
                child: CustomIconButton(
                  icon: ThunderIcons.chevronLeft,
                  onTap: onBack ?? () => Navigator.pop(context),
                ),
              ),

            if (leading != null)
              Align(
                alignment: Alignment.centerLeft,
                child: leading,
              ),

            // (3) Actions (오른쪽)
            if (actions != null && actions!.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: Sizes.spacing4,
                  children: actions!.map((action) {
                    switch (action.type) {
                      case CustomAppBarActionType.text:
                        return InkWell(
                          onTap: action.onTap,
                          borderRadius: BorderRadius.circular(Sizes.radius16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Sizes.spacing8,
                              vertical: Sizes.spacing4,
                            ),
                            child: Text(
                              action.text!,
                              style: textTheme.textTitle18,
                            ),
                          ),
                        );
                      case CustomAppBarActionType.icon:
                        return CustomIconButton(
                          icon: action.icon!,
                          onTap: action.onTap,
                          size: Sizes.icon24,
                          color: ColorName.white,
                        );
                      case CustomAppBarActionType.child:
                        return action.child!;
                      default:
                        return const SizedBox.shrink();
                    }
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
