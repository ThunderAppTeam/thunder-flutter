import 'package:flutter/material.dart';
import 'package:noon_body/core/theme/gen/fonts.gen.dart';
import 'package:noon_body/core/theme/constants/sizes.dart';
import 'app_text_theme.dart';

const AppTextTheme defaultTextTheme = AppTextTheme(
  // #####--- Heading styles (큰 텍스트, 화면 제목 및 메인 글자)
  textHead32: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize32,
    height: Sizes.lineHeight48 / Sizes.fontSize32,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  ),
  textHead24: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize24,
    height: Sizes.lineHeight36 / Sizes.fontSize24,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  ),

  // #####--- Title styles (살짝 Bold감이 있는 작은 텍스트)
  textTitle20: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize20,
    height: Sizes.lineHeight24 / Sizes.fontSize20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
  textTitle18: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize18,
    height: Sizes.lineHeight24 / Sizes.fontSize18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
  textTitle16: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize16,
    height: Sizes.lineHeight22 / Sizes.fontSize16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),

  // #####--- Subtitle styles (Bold감이 있는 작은 텍스트)
  textSubtitle14: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize14,
    height: Sizes.lineHeight21 / Sizes.fontSize14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
  textSubtitle12: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize12,
    height: Sizes.lineHeight18 / Sizes.fontSize12,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),

  // #####--- Body styles (작은 텍스트)
  textBody18: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize18,
    height: Sizes.lineHeight24 / Sizes.fontSize18,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  ),
  textBody16: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize16,
    height: Sizes.lineHeight24 / Sizes.fontSize16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  ),
  textBody14: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize14,
    height: Sizes.lineHeight20 / Sizes.fontSize14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  ),
);
