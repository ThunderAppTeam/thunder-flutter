import 'package:flutter/material.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';

class CustomCircularIndicator extends StatelessWidget {
  const CustomCircularIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: ColorName.white,
      ),
    );
  }
}
