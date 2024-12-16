import 'package:flutter/material.dart';

@immutable
class AppTextTheme extends ThemeExtension<AppTextTheme> {
  const AppTextTheme({
    required this.textHead32,
    required this.textHead18,
    required this.textHead16,
    required this.textSubtitle24,
    required this.textSubtitle16,
    required this.textSubtitle14,
    required this.textSubtitle12,
    required this.textBody16,
    required this.textBody14,
    required this.textBody12,
  });
  final TextStyle textHead32;
  final TextStyle textHead18;
  final TextStyle textHead16;
  final TextStyle textSubtitle24;
  final TextStyle textSubtitle16;
  final TextStyle textSubtitle14;
  final TextStyle textSubtitle12;
  final TextStyle textBody16;
  final TextStyle textBody14;
  final TextStyle textBody12;

  @override
  ThemeExtension<AppTextTheme> copyWith({
    TextStyle? textHead32,
    TextStyle? textHead18,
    TextStyle? textHead16,
    TextStyle? textSubtitle24,
    TextStyle? textSubtitle16,
    TextStyle? textSubtitle14,
    TextStyle? textSubtitle12,
    TextStyle? textBody16,
    TextStyle? textBody14,
    TextStyle? textBody12,
  }) {
    return AppTextTheme(
      textBody16: textBody16 ?? this.textBody16,
      textBody14: textBody14 ?? this.textBody14,
      textBody12: textBody12 ?? this.textBody12,
      textSubtitle24: textSubtitle24 ?? this.textSubtitle24,
      textSubtitle16: textSubtitle16 ?? this.textSubtitle16,
      textSubtitle14: textSubtitle14 ?? this.textSubtitle14,
      textSubtitle12: textSubtitle12 ?? this.textSubtitle12,
      textHead32: textHead32 ?? this.textHead32,
      textHead18: textHead18 ?? this.textHead18,
      textHead16: textHead16 ?? this.textHead16,
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
      textBody16: TextStyle.lerp(textBody16, other.textBody16, t)!,
      textBody14: TextStyle.lerp(textBody14, other.textBody14, t)!,
      textBody12: TextStyle.lerp(textBody12, other.textBody12, t)!,
      textSubtitle24: TextStyle.lerp(textSubtitle24, other.textSubtitle24, t)!,
      textSubtitle16: TextStyle.lerp(textSubtitle16, other.textSubtitle16, t)!,
      textSubtitle14: TextStyle.lerp(textSubtitle14, other.textSubtitle14, t)!,
      textSubtitle12: TextStyle.lerp(textSubtitle12, other.textSubtitle12, t)!,
      textHead32: TextStyle.lerp(textHead32, other.textHead32, t)!,
      textHead18: TextStyle.lerp(textHead18, other.textHead18, t)!,
      textHead16: TextStyle.lerp(textHead16, other.textHead16, t)!,
    );
  }
}
