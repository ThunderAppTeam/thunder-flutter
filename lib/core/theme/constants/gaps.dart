import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';

abstract class Gaps {
  // Vertical
  static const v2 = SizedBox(height: Sizes.spacing2);
  static const v6 = SizedBox(height: Sizes.spacing6);
  static const v8 = SizedBox(height: Sizes.spacing8);
  static const v12 = SizedBox(height: Sizes.spacing12);
  static const v16 = SizedBox(height: Sizes.spacing16);
  static const v24 = SizedBox(height: Sizes.spacing24);
  static const v32 = SizedBox(height: Sizes.spacing32);

  // Horizontal
  static const h4 = SizedBox(width: Sizes.spacing4);
  static const h8 = SizedBox(width: Sizes.spacing8);
  static const h12 = SizedBox(width: Sizes.spacing12);
  static const h16 = SizedBox(width: Sizes.spacing16);
}
