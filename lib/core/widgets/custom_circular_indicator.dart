import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';

class CustomCircularIndicator extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color color;
  final double padding;

  const CustomCircularIndicator({
    super.key,
    this.size = Sizes.circularIndicatorSize32,
    this.strokeWidth = Sizes.circularIndicatorStrokeWidth4,
    this.color = ColorName.white,
    this.padding = Sizes.spacing4,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: CircularProgressIndicator(
          color: color,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}
