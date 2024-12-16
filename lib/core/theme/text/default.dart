import 'package:flutter/material.dart';
import 'package:noon_body/core/theme/gen/fonts.gen.dart';
import 'package:noon_body/core/theme/sizes.dart';
import 'app_text_theme.dart';

const AppTextTheme defaultTextTheme = AppTextTheme(
  // Heading styles (큰 텍스트, 화면 제목 및 메인 글자)
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

  // Title styles (살짝 Bold감이 있는 작은 텍스트)
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
    height: Sizes.lineHeight20 / Sizes.fontSize16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
);
