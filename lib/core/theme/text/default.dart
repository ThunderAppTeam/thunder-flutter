import 'package:flutter/material.dart';
import 'package:noon_body/core/theme/gen/fonts.gen.dart';
import 'package:noon_body/core/theme/sizes.dart';
import 'app_text_theme.dart';

const AppTextTheme defaultTextTheme = AppTextTheme(
  // Body styles
  textBody16: TextStyle(
    fontSize: Sizes.fontSize16,
    fontWeight: FontWeight.w400,
  ),
  textBody14: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize14,
    fontWeight: FontWeight.w400,
  ),
  textBody12: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize12,
    fontWeight: FontWeight.w400,
  ),

  // Subtitle styles
  textSubtitle24: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize24,
    height: 36 / 24,
    fontWeight: FontWeight.w600,
  ),
  textSubtitle16: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
  ),
  textSubtitle14: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize14,
    fontWeight: FontWeight.w600,
  ),
  textSubtitle12: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize12,
    fontWeight: FontWeight.w600,
  ),

  // Heading styles
  textHead32: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize32,
    height: 48 / 32,
    fontWeight: FontWeight.w700,
  ),
  textHead18: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize18,
    height: 27 / 18,
    fontWeight: FontWeight.w700,
  ),
  textHead16: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize16,
    height: 24 / 16,
    fontWeight: FontWeight.w700,
  ),
);
