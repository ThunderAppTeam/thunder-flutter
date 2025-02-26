import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Color? color;
  final bool isEnabled;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = Sizes.icon24,
    this.color = ColorName.white,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(Sizes.spacing8),
          child: Icon(icon, size: size, color: color),
        ),
      ),
    );
  }
}
