import 'package:flutter/material.dart';
import 'package:noon_body/core/theme/constants/styles.dart';

class CurstomButtonAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isEnabled;

  const CurstomButtonAnimation({
    super.key,
    required this.child,
    required this.onPressed,
    this.isEnabled = true,
  });

  @override
  State<CurstomButtonAnimation> createState() => _CurstomButtonAnimationState();
}

class _CurstomButtonAnimationState extends State<CurstomButtonAnimation> {
  bool _isPressed = false;

  void _updatePressedState(bool isPressed) {
    if (widget.isEnabled) {
      setState(() => _isPressed = isPressed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Styles.duration200,
      opacity: widget.isEnabled ? Styles.opacity100 : Styles.opacity30,
      child: GestureDetector(
        onTapDown: (_) => _updatePressedState(true),
        onTapUp: (_) {
          _updatePressedState(false);
          widget.onPressed?.call();
        },
        onTapCancel: () => _updatePressedState(false),
        child: AnimatedScale(
          scale: _isPressed ? Styles.scale95 : Styles.scale100,
          duration: Styles.duration100,
          child: widget.child,
        ),
      ),
    );
  }
}
