import 'package:flutter/material.dart';

@immutable
class AppTextTheme extends ThemeExtension<AppTextTheme> {
  // Head
  final TextStyle textHead32;
  final TextStyle textHead24;

  // Title
  final TextStyle textTitle20;
  final TextStyle textTitle18;
  final TextStyle textTitle16;

  // Subtitle
  final TextStyle textSubtitle14;
  final TextStyle textSubtitle12;

  // Body
  final TextStyle textBody18;
  final TextStyle textBody14;

  const AppTextTheme({
    required this.textHead32,
    required this.textHead24,
    required this.textTitle20,
    required this.textTitle18,
    required this.textTitle16,
    required this.textSubtitle14,
    required this.textSubtitle12,
    required this.textBody18,
    required this.textBody14,
  });

  @override
  ThemeExtension<AppTextTheme> copyWith({
    TextStyle? textHead32,
    TextStyle? textHead24,
    TextStyle? textTitle20,
    TextStyle? textTitle18,
    TextStyle? textTitle16,
    TextStyle? textSubtitle14,
    TextStyle? textSubtitle12,
    TextStyle? textBody18,
    TextStyle? textBody14,
  }) {
    return AppTextTheme(
      textHead32: textHead32 ?? this.textHead32,
      textHead24: textHead24 ?? this.textHead24,
      textTitle20: textTitle20 ?? this.textTitle20,
      textTitle18: textTitle18 ?? this.textTitle18,
      textTitle16: textTitle16 ?? this.textTitle16,
      textSubtitle14: textSubtitle14 ?? this.textSubtitle14,
      textSubtitle12: textSubtitle12 ?? this.textSubtitle12,
      textBody18: textBody18 ?? this.textBody18,
      textBody14: textBody14 ?? this.textBody14,
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
      textTitle20: TextStyle.lerp(textTitle20, other.textTitle20, t)!,
      textTitle18: TextStyle.lerp(textTitle18, other.textTitle18, t)!,
      textTitle16: TextStyle.lerp(textTitle16, other.textTitle16, t)!,
      textSubtitle14: TextStyle.lerp(textSubtitle14, other.textSubtitle14, t)!,
      textSubtitle12: TextStyle.lerp(textSubtitle12, other.textSubtitle12, t)!,
      textBody18: TextStyle.lerp(textBody18, other.textBody18, t)!,
      textBody14: TextStyle.lerp(textBody14, other.textBody14, t)!,
    );
  }
}
