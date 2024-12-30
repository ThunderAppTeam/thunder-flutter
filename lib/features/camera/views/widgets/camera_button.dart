import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/constants/styles.dart';

class CameraButton extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;
  final double size;
  final bool isEnabled;

  const CameraButton({
    super.key,
    required this.onTap,
    required this.child,
    this.size = Sizes.icon48,
    this.isEnabled = true,
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
        onTap: widget.isEnabled ? widget.onTap : null,
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: Opacity(
            opacity: widget.isEnabled ? Styles.opacity100 : Styles.opacity0,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
