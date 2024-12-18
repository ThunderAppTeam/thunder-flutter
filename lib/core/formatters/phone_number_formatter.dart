import 'package:flutter/services.dart';

class KoreanPhoneNumberFormatter extends TextInputFormatter {
  static const seoulMaxLength = 10;
  static const mobileMaxLength = 11;
  static const representativeMaxLength = 8;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final formatted = _formatNumber(newText);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatNumber(String text) {
    // 1. 서울 (02)
    if (text.startsWith('02')) {
      return _formatSeoulNumber(text);
    }
    // 2. 휴대폰 (010), 지역번호 (0XX)
    if (text.startsWith('0')) {
      return _formatMobileAndRegionalNumber(text);
    }
    // 3. 대표번호 (15XX, 16XX, 18XX 등)
    if (text.startsWith(RegExp(r'1(5|6|8)'))) {
      return _formatRepresentativeNumber(text);
    }
    return text;
  }

  String _formatSeoulNumber(String text) {
    if (text.length <= 2) return text;
    // 02-XXX
    if (text.length <= 5) {
      return '${text.substring(0, 2)}-${text.substring(2)}';
    }
    // 02-XXX-XXXX
    if (text.length <= 9) {
      return '${text.substring(0, 2)}-${text.substring(2, 5)}-${text.substring(5)}';
    }
    // 02-XXXX-XXXX
    if (text.length <= seoulMaxLength) {
      return '${text.substring(0, 2)}-${text.substring(2, 6)}-${text.substring(6)}';
    }
    // 최대 10자리까지만 포맷
    return text;
  }

  String _formatMobileAndRegionalNumber(String text) {
    if (text.length <= 3) return text;
    // 010-X
    if (text.length <= 6) {
      return '${text.substring(0, 3)}-${text.substring(3)}';
    }
    // 010-XXX-XXXX
    if (text.length <= 10) {
      return '${text.substring(0, 3)}-${text.substring(3, 6)}-${text.substring(6)}';
    }
    // 010-XXXX-XXXX
    if (text.length <= mobileMaxLength) {
      return '${text.substring(0, 3)}-${text.substring(3, 7)}-${text.substring(7)}';
    }
    // 최대 11자리까지만 포맷
    return text;
  }

  String _formatRepresentativeNumber(String text) {
    if (text.length <= 4) return text;
    // 1588-XXXX
    if (text.length <= representativeMaxLength) {
      return '${text.substring(0, 4)}-${text.substring(4)}';
    }
    // 최대 8자리까지만 포맷
    return text;
  }
}
