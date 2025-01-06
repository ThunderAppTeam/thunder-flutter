import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thunder/core/constants/age_consts.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:thunder/features/onboarding/providers/onboarding_provider.dart';
import 'package:thunder/core/widgets/buttons/custom_wide_button.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_scaffold.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_text_field.dart';
import 'package:thunder/generated/l10n.dart';

enum DateField {
  year(hintText: 'YYYY', maxLength: 4),
  month(hintText: 'MM', maxLength: 2),
  day(hintText: 'DD', maxLength: 2);

  final String hintText;
  final int maxLength;

  const DateField({
    required this.hintText,
    required this.maxLength,
  });
}

class BirthdatePage extends ConsumerStatefulWidget {
  const BirthdatePage({super.key});

  @override
  ConsumerState<BirthdatePage> createState() => _BirthdatePageState();
}

class _BirthdatePageState extends ConsumerState<BirthdatePage> {
  final Map<DateField, TextEditingController> _controllers = {};
  final Map<DateField, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();
    for (final field in DateField.values) {
      _controllers[field] = TextEditingController();
      _focusNodes[field] = FocusNode();
    }
  }

  @override
  void dispose() {
    for (final field in DateField.values) {
      _controllers[field]!.dispose();
      _focusNodes[field]!.dispose();
    }
    super.dispose();
  }

  DateTime? get _selectedDate {
    final year = _controllers[DateField.year]!.text;
    final month = _controllers[DateField.month]!.text;
    final day = _controllers[DateField.day]!.text;
    try {
      return DateFormat('yyyy-MM-dd').parseStrict('$year-$month-$day');
    } catch (e) {
      return null;
    }
  }

  bool get _isDateValid {
    final date = _selectedDate;
    if (date == null) return false;
    final today = DateTime.now();
    // 미래 날짜 체크
    if (date.isAfter(today)) return false;
    // 너무 먼 과거 체크
    final maxAge =
        today.subtract(Duration(days: AgeConsts.maxAge * AgeConsts.daysInYear));
    if (date.isBefore(maxAge)) return false;
    return true;
  }

  bool get _isAgeValid {
    final date = _selectedDate;
    if (date == null) return false;
    final today = DateTime.now();
    // 만 나이 계산
    int age = today.year - date.year;
    if (today.month < date.month ||
        (today.month == date.month && today.day < date.day)) {
      age--;
    }
    return age >= AgeConsts.minAge;
  }

  void _handleNextPress() {
    if (!_isDateValid) {
      _showAlertBottomSheet(
        title: S.of(context).birthdateInvalidDateTitle,
        subtitle: S.of(context).birthdateInvalidDateSubtitle,
      );
      return;
    }
    if (!_isAgeValid) {
      _showAlertBottomSheet(
        title: S.of(context).birthdateInvalidAgeTitle,
        subtitle: S.of(context).birthdateInvalidAgeSubtitle,
      );
      return;
    }
    final notifier = ref.read(onboardingProvider.notifier);
    notifier.setBirthdate(_selectedDate!);
    notifier.pushNextStep(
      context: context,
      currentStep: OnboardingStep.birthdate,
    );
  }

  void _showAlertBottomSheet(
      {required String title, required String subtitle}) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CustomBottomSheet(
        title: title,
        subtitle: subtitle,
        buttonText: S.of(context).commonConfirm,
      ),
    );
  }

  void _fieldFocusChange(String value, DateField current) {
    if (value.length == current.maxLength) {
      _focusNodes[current]!.unfocus();
      final nextIndex = DateField.values.indexOf(current) + 1;
      if (nextIndex < DateField.values.length) {
        _focusNodes[DateField.values[nextIndex]]!.requestFocus();
      }
    }
  }

  Widget _buildDateField(DateField field) {
    return IntrinsicWidth(
      child: OnboardingTextField(
        controller: _controllers[field]!,
        focusNode: _focusNodes[field]!,
        hintText: field.hintText,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(field.maxLength),
        ],
        onChanged: (value) {
          setState(() {});
          _fieldFocusChange(value, field);
        },
      ),
    );
  }

  bool _isFieldFilled(DateField field) {
    return _controllers[field]!.text.length == field.maxLength;
  }

  bool get _isButtonEnabled {
    return _isFieldFilled(DateField.year) &&
        _isFieldFilled(DateField.month) &&
        _isFieldFilled(DateField.day);
  }

  @override
  Widget build(BuildContext context) {
    final nickname = ref.read(onboardingProvider).nickname!;
    final textTheme = getTextTheme(context);
    final divider = [
      Gaps.h16,
      Text('/', style: textTheme.textHead24),
      Gaps.h16,
    ];
    return OnboardingScaffold(
      title: S.of(context).birthdateTitle(nickname),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildDateField(DateField.year),
          ...divider,
          _buildDateField(DateField.month),
          ...divider,
          _buildDateField(DateField.day),
        ],
      ),
      guideText: S.of(context).birthdateGuideText,
      bottomButton: CustomWideButton(
        text: S.of(context).commonNext,
        onPressed: _handleNextPress,
        isEnabled: _isButtonEnabled,
      ),
    );
  }
}
