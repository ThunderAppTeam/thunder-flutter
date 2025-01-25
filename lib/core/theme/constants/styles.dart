import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';

abstract class Styles {
  // Opacity
  static const double opacity0 = 0.0;
  static const double opacity30 = 0.3;
  static const double opacity50 = 0.5;
  static const double opacity70 = 0.7;
  static const double opacity80 = 0.8;
  static const double opacity90 = 0.9;
  static const double opacity100 = 1.0;

  // Scale
  static const double scale0 = 0.0;
  static const double scale98 = 0.98;
  static const double scale100 = 1.0;

  // BorderSide
  static const BorderSide whiteBorder2 = BorderSide(
    color: ColorName.white,
    width: Sizes.borderWidth1,
  );
  // Duration
  static const Duration duration100 = Duration(milliseconds: 100);
  static const Duration duration200 = Duration(milliseconds: 200);

  // Page Transition Duration
  static const Duration pageTransitionDuration300 = Duration(milliseconds: 300);
  static const Duration pageTransitionDuration500 = Duration(milliseconds: 500);
}
