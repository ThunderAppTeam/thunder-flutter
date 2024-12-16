import 'package:flutter/material.dart';

@immutable
class AppTextTheme extends ThemeExtension<AppTextTheme> {
  // Head
  final TextStyle textHead32;
  final TextStyle textHead24;

  // Title
  final TextStyle textTitle18;
  final TextStyle textTitle16;

  const AppTextTheme({
    required this.textHead32,
    required this.textHead24,
    required this.textTitle18,
    required this.textTitle16,
  });

  @override
  ThemeExtension<AppTextTheme> copyWith({
    TextStyle? textHead32,
    TextStyle? textHead24,
    TextStyle? textTitle18,
    TextStyle? textTitle16,
  }) {
    return AppTextTheme(
      textHead32: textHead32 ?? this.textHead32,
      textHead24: textHead24 ?? this.textHead24,
      textTitle18: textTitle18 ?? this.textTitle18,
      textTitle16: textTitle16 ?? this.textTitle16,
    );
  }

  @override
  ThemeExtension<AppTextTheme> lerp(
    covariant ThemeExtension<AppTextTheme>? other,
    double t,
  ) {
    if (other is! AppTextTheme) {
      return this;
    }

    return AppTextTheme(
      textHead32: TextStyle.lerp(textHead32, other.textHead32, t)!,
      textHead24: TextStyle.lerp(textHead24, other.textHead24, t)!,
      textTitle18: TextStyle.lerp(textTitle18, other.textTitle18, t)!,
      textTitle16: TextStyle.lerp(textTitle16, other.textTitle16, t)!,
    );
  }
}
