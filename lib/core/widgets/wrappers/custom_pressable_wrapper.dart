import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/styles.dart';

class CustomPressableWrapper extends StatefulWidget {
  final Widget child;
  final bool isEnabled;

  const CustomPressableWrapper({
    super.key,
    required this.child,
    this.isEnabled = true,
  });

  @override
  State<CustomPressableWrapper> createState() => _CustomPressableWrapperState();
}

class _CustomPressableWrapperState extends State<CustomPressableWrapper> {
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
          if (widget.isEnabled) {
            _updatePressedState(false);
          }
        },
        onTapCancel: () => _updatePressedState(false),
        child: AnimatedScale(
          scale: _isPressed ? Styles.scale98 : Styles.scale100,
          duration: Styles.duration100,
          child: widget.child,
        ),
      ),
    );
  }
}
