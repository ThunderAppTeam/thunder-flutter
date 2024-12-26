// lib/core/extensions/text_style.dart
import 'package:flutter/material.dart';

extension TextStyleX on TextStyle {
  TextStyle withOpacity(double opacity) {
    return copyWith(
      color: color?.withOpacity(opacity),
    );
  }
}
