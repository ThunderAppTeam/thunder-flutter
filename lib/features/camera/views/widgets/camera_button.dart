import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';

class CameraButton extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;
  final double size;

  const CameraButton({
    super.key,
    required this.onTap,
    required this.child,
    this.size = Sizes.icon48,
  });

  @override
  State<CameraButton> createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: widget.onTap,
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: widget.child,
        ),
      ),
    );
  }
}
