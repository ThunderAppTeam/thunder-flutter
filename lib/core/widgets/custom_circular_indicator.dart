import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';

class CustomCircularIndicator extends StatelessWidget {
  const CustomCircularIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Sizes.circularIndicatorSize32,
        height: Sizes.circularIndicatorSize32,
        child: Padding(
          padding: EdgeInsets.all(Sizes.spacing4),
          child: CircularProgressIndicator(
            color: ColorName.white,
            strokeWidth: Sizes.circularIndicatorStrokeWidth4,
          ),
        ),
      ),
    );
  }
}
