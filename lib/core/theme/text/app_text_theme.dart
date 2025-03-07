import 'package:flutter/material.dart';

@immutable
class AppTextTheme extends ThemeExtension<AppTextTheme> {
  // Custom
  final TextStyle customStyle;
  // Head
  final TextStyle textHead32;
  final TextStyle textHead24;

  // Title
  final TextStyle textTitle24;
  final TextStyle textTitle20;
  final TextStyle textTitle18;
  final TextStyle textTitle16;

  // Subtitle
  final TextStyle textSubtitle14;
  final TextStyle textSubtitle12;

  // Body
  final TextStyle textBody18;
  final TextStyle textBody16;
  final TextStyle textBody14;
  final TextStyle textBody12;

  // Small
  final TextStyle textSmall10;

  const AppTextTheme({
    required this.customStyle,
    required this.textHead32,
    required this.textHead24,
    required this.textTitle24,
    required this.textTitle20,
    required this.textTitle18,
    required this.textTitle16,
    required this.textSubtitle14,
    required this.textSubtitle12,
    required this.textBody18,
    required this.textBody16,
    required this.textBody14,
    required this.textBody12,
    required this.textSmall10,
  });

  @override
  ThemeExtension<AppTextTheme> copyWith({
    TextStyle? customStyle,
    TextStyle? textHead32,
    TextStyle? textHead24,
    TextStyle? textTitle24,
    TextStyle? textTitle20,
    TextStyle? textTitle18,
    TextStyle? textTitle16,
    TextStyle? textSubtitle14,
    TextStyle? textSubtitle12,
    TextStyle? textBody18,
    TextStyle? textBody16,
    TextStyle? textBody14,
    TextStyle? textBody12,
    TextStyle? textSmall10,
  }) {
    return AppTextTheme(
      customStyle: customStyle ?? this.customStyle,
      textHead32: textHead32 ?? this.textHead32,
      textHead24: textHead24 ?? this.textHead24,
      textTitle24: textTitle24 ?? this.textTitle24,
      textTitle20: textTitle20 ?? this.textTitle20,
      textTitle18: textTitle18 ?? this.textTitle18,
      textTitle16: textTitle16 ?? this.textTitle16,
      textSubtitle14: textSubtitle14 ?? this.textSubtitle14,
      textSubtitle12: textSubtitle12 ?? this.textSubtitle12,
      textBody18: textBody18 ?? this.textBody18,
      textBody16: textBody16 ?? this.textBody16,
      textBody14: textBody14 ?? this.textBody14,
      textBody12: textBody12 ?? this.textBody12,
      textSmall10: textSmall10 ?? this.textSmall10,
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
      customStyle: TextStyle.lerp(customStyle, other.customStyle, t)!,
      textHead32: TextStyle.lerp(textHead32, other.textHead32, t)!,
      textHead24: TextStyle.lerp(textHead24, other.textHead24, t)!,
      textTitle24: TextStyle.lerp(textTitle24, other.textTitle24, t)!,
      textTitle20: TextStyle.lerp(textTitle20, other.textTitle20, t)!,
      textTitle18: TextStyle.lerp(textTitle18, other.textTitle18, t)!,
      textTitle16: TextStyle.lerp(textTitle16, other.textTitle16, t)!,
      textSubtitle14: TextStyle.lerp(textSubtitle14, other.textSubtitle14, t)!,
      textSubtitle12: TextStyle.lerp(textSubtitle12, other.textSubtitle12, t)!,
      textBody18: TextStyle.lerp(textBody18, other.textBody18, t)!,
      textBody16: TextStyle.lerp(textBody16, other.textBody16, t)!,
      textBody14: TextStyle.lerp(textBody14, other.textBody14, t)!,
      textBody12: TextStyle.lerp(textBody12, other.textBody12, t)!,
      textSmall10: TextStyle.lerp(textSmall10, other.textSmall10, t)!,
    );
  }
}
