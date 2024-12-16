import 'package:flutter/material.dart';
import 'package:noon_body/core/theme/constants/sizes.dart';
import 'package:noon_body/core/theme/constants/styles.dart';
import 'package:noon_body/core/utils/theme_utils.dart';

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
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(Styles.radius16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Sizes.spacing16),
              child: Center(
                child: Text(
                  widget.text,
                  style: getTextTheme(context).textTitle18.copyWith(
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
