import 'package:flutter/material.dart';
import 'package:noon_body/core/theme/text/app_text_theme.dart';

AppTextTheme getTextTheme(BuildContext context) {
  // Todo: 다크 모드 적용 및 테마 변경 시 텍스트 테마 변경 로직 추가
  return Theme.of(context).extension<AppTextTheme>()!;
}
