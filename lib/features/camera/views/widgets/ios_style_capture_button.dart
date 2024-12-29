import 'package:flutter/material.dart';

class IOSStyleCaptureButton extends StatefulWidget {
  final VoidCallback onTap;
  final double size;
  final Color color;
  final double borderWidth;

  const IOSStyleCaptureButton({
    super.key,
    required this.onTap,
    this.size = 80.0,
    this.color = Colors.white,
    this.borderWidth = 5.0,
  });

  @override
  State<IOSStyleCaptureButton> createState() => _IOSStyleCaptureButtonState();
}

class _IOSStyleCaptureButtonState extends State<IOSStyleCaptureButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
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
              duration: const Duration(milliseconds: 150),
              width: _isPressed ? widget.size - 24 : widget.size - 16,
              height: _isPressed ? widget.size - 24 : widget.size - 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
