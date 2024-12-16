import 'package:flutter/material.dart';
import 'package:noon_body/core/theme/sizes.dart';

abstract class Gaps {
  // Vertical
  static const v8 = SizedBox(height: Sizes.spacing8);
  static const v32 = SizedBox(height: Sizes.spacing32);

  // Horizontal
  static const h8 = SizedBox(width: Sizes.spacing8);
  static const h32 = SizedBox(width: Sizes.spacing32);
}
