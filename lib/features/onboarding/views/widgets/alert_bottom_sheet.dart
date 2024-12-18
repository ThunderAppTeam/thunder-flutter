import 'package:flutter/material.dart';
import 'package:noon_body/core/widgets/bottom_sheets/custom_bottom_sheet.dart';

class AlertBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;

  const AlertBottomSheet({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
    this.onPressed,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = '확인',
    VoidCallback? onPressed,
  }) {
    return CustomBottomSheet.show(
      context: context,
      title: title,
      subtitle: message,
      buttonText: buttonText,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: title,
      subtitle: message,
      buttonText: buttonText,
      onPressed: onPressed,
    );
  }
}
