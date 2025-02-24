import 'package:flutter/material.dart';
import 'package:thunder/core/theme/gen/fonts.gen.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'app_text_theme.dart';

const AppTextTheme defaultTextTheme = AppTextTheme(
  customStyle: TextStyle(
    fontFamily: FontFamily.pretendard,
    color: Colors.white,
    height: Sizes.defaultFontHeight,
  ),
  // #####--- Heading styles (큰 텍스트, 화면 제목 및 메인 글자)
  textHead32: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize32,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    height: Sizes.defaultFontHeight,
  ),
  textHead24: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize24,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    height: Sizes.defaultFontHeight,
  ),

  // #####--- Title styles (살짝 Bold감이 있는 작은 텍스트)
  textTitle24: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize24,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: Sizes.defaultFontHeight,
  ),
  textTitle20: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: Sizes.defaultFontHeight,
  ),
  textTitle18: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: Sizes.defaultFontHeight,
  ),
  textTitle16: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: Sizes.defaultFontHeight,
  ),

  // #####--- Subtitle styles (Bold감이 있는 작은 텍스트)
  textSubtitle14: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: Sizes.defaultFontHeight,
  ),
  textSubtitle12: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize12,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: Sizes.defaultFontHeight,
  ),

  // #####--- Body styles (작은 텍스트)
  textBody18: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize18,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    height: Sizes.defaultFontHeight,
  ),
  textBody16: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    height: Sizes.defaultFontHeight,
  ),
  textBody14: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    height: Sizes.defaultFontHeight,
  ),
  textBody12: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize12,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    height: Sizes.defaultFontHeight,
  ),

  // ##### --- Small Style (더 작은 텍스트)
  textSmall10: TextStyle(
    fontFamily: FontFamily.pretendard,
    fontSize: Sizes.fontSize10,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: Sizes.defaultFontHeight,
  ),
);
