import 'package:flutter/material.dart';
import 'package:noon_body/core/theme/gen/colors.gen.dart';

abstract class Styles {
  // Opacity
  static const double opacity30 = 0.3;
  static const double opacity50 = 0.05;
  static const double opacity80 = 0.8;
  static const double opacity100 = 1.0;

  // Scale
  static const double scale95 = 0.95;
  static const double scale100 = 1.0;

  // Radius
  static const double radius16 = 16.0;

  // Border width
  static const double borderWidth2 = 2.0;

  // BorderSide
  static const BorderSide whiteBorder2 = BorderSide(
    color: ColorName.white,
    width: borderWidth2,
  );

  // Duration
  static const Duration duration100 = Duration(milliseconds: 100);
  static const Duration duration200 = Duration(milliseconds: 200);
}
