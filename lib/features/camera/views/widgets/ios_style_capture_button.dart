import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/styles.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';

class IOSStyleCaptureButton extends StatefulWidget {
  final VoidCallback? onTap;
  final double size;
  final Color color;
  final double borderWidth;
  final bool isEnabled;

  const IOSStyleCaptureButton({
    super.key,
    required this.onTap,
    this.size = 80.0,
    this.color = ColorName.white,
    this.borderWidth = 5.0,
    this.isEnabled = true,
  });

  @override
  State<IOSStyleCaptureButton> createState() => _IOSStyleCaptureButtonState();
}

class _IOSStyleCaptureButtonState extends State<IOSStyleCaptureButton> {
  bool _isPressed = false;

  double get _defaultInnerSizeRatio => 0.825;
  double get _pressedInnerSizeRatio => 0.75;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:
          widget.isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp:
          widget.isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel:
          widget.isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: widget.isEnabled ? widget.onTap : null,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Opacity(
          opacity: widget.isEnabled ? Styles.opacity100 : Styles.opacity30,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 바깥 원 (테두리)
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.color,
                    width: widget.borderWidth,
                  ),
                ),
              ),
              // 안쪽 원 (애니메이션)
              AnimatedContainer(
                duration: Styles.duration100,
                width: widget.size *
                    (widget.isEnabled && _isPressed
                        ? _pressedInnerSizeRatio
                        : _defaultInnerSizeRatio),
                height: widget.size *
                    (widget.isEnabled && _isPressed
                        ? _pressedInnerSizeRatio
                        : _defaultInnerSizeRatio),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
