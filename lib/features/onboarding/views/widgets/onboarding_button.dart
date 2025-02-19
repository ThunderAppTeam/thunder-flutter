import 'package:flutter/material.dart';

class OnboardingButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final Color backgroundColor;
  final Color textColor;

  const OnboardingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  });

  @override
  State<OnboardingButton> createState() => _OnboardingButtonState();
}

class _OnboardingButtonState extends State<OnboardingButton> {
  bool _isPressed = false;

  void _updatePressedState(bool isPressed) {
    if (widget.isEnabled) {
      setState(() => _isPressed = isPressed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: widget.isEnabled ? 1.0 : 0.3,
      child: GestureDetector(
        onTapDown: (_) => _updatePressedState(true),
        onTapUp: (_) {
          _updatePressedState(false);
          widget.onPressed?.call();
        },
        onTapCancel: () => _updatePressedState(false),
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 18,
                    color: widget.textColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
