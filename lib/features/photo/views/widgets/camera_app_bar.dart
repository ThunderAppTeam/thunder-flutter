import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/widgets/buttons/custom_icon_button.dart';
import 'package:thunder/core/theme/icon/thunder_icons_icons.dart';

class CameraAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onClose;
  final VoidCallback onFlash;
  final IconData flashIcon;
  final bool hasPermission;
  final bool isFlashModeAvailable;

  const CameraAppBar({
    super.key,
    required this.onClose,
    required this.onFlash,
    required this.flashIcon,
    required this.hasPermission, // 권한이 없을 때 flash 버튼 비활성화
    required this.isFlashModeAvailable,
  });

  @override
  Size get preferredSize => const Size.fromHeight(Sizes.appBarHeight48);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      title: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.spacing8,
          vertical: Sizes.spacing8,
        ),
        child: Row(
          children: [
            const Expanded(child: SizedBox()),
            if (hasPermission && isFlashModeAvailable)
              CustomIconButton(
                icon: flashIcon,
                onTap: onFlash,
              ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: CustomIconButton(
                  icon: ThunderIcons.closeSquareLight,
                  onTap: onClose,
                ),
              ),
            ),
          ],
        ),
      ),
      titleSpacing: 0,
    );
  }
}
