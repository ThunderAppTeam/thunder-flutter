import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:noon_body/core/router/routes.dart';
import 'package:noon_body/core/theme/constants/gaps.dart';
import 'package:noon_body/core/utils/theme_utils.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_button.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_scaffold.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_text_field.dart';
import 'package:noon_body/core/widgets/bottom_sheets/custom_alert_bottom_sheet.dart';
import 'package:noon_body/generated/l10n.dart';

class BirthdatePage extends StatefulWidget {
  const BirthdatePage({super.key});

  @override
  State<BirthdatePage> createState() => _BirthdatePageState();
}

class _BirthdatePageState extends State<BirthdatePage> {
  final _yearController = TextEditingController();
  final _monthController = TextEditingController();
  final _dayController = TextEditingController();
  // FocusNode
  final _yearFocus = FocusNode();
  final _monthFocus = FocusNode();
  final _dayFocus = FocusNode();

  bool get _isButtonEnabled {
    return _yearController.text.length == 4 &&
        _monthController.text.length == 2 &&
        _dayController.text.length == 2;
  }

  bool get _isAgeValid {
    final year = int.tryParse(_yearController.text);
    final month = int.tryParse(_monthController.text);
    final day = int.tryParse(_dayController.text);

    if (year == null || month == null || day == null) return false;

    final birthDate = DateTime(year, month, day);
    final today = DateTime.now();
    final age = today.year - birthDate.year;
    final monthDiff = today.month - birthDate.month;

    // 생일이 아직 지나지 않았다면 나이에서 1을 빼줌
    if (monthDiff < 0 || (monthDiff == 0 && today.day < birthDate.day)) {
      return age - 1 >= 18;
    }
    return age >= 18;
  }

  void _handleNextPress() {
    if (_isAgeValid) {
      context.pushNamed(Routes.gender.name);
    } else {
      _showAgeRestrictionBottomSheet();
    }
  }

  void _showAgeRestrictionBottomSheet() {
    CustomAlertBottomSheet.show(
      context: context,
      title: '서비스 이용가능 연령이 아니에요',
      message: '만 18세 미만은 썬더를 이용하실 수 없어요. 나중에 다시 만나요.',
    );
  }

  void _fieldFocusChange(String value, int maxLength, FocusNode currentFocus,
      FocusNode? nextFocus) {
    if (value.length == maxLength) {
      currentFocus.unfocus();
      nextFocus?.requestFocus();
    }
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();

    _yearFocus.dispose();
    _monthFocus.dispose();
    _dayFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nickname = "썬더닉네임999";
    final textTheme = getTextTheme(context);
    final divider = Text('/', style: textTheme.textHead24);
    return OnboardingScaffold(
      title: S.of(context).birthdateTitle(nickname),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: OnboardingTextField(
                controller: _yearController,
                focusNode: _yearFocus,
                hintText: 'YYYY',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                onChanged: (value) {
                  setState(() {});
                  _fieldFocusChange(value, 4, _yearFocus, _monthFocus);
                }),
          ),
          Gaps.h16,
          divider,
          Gaps.h16,
          Expanded(
            flex: 3,
            child: OnboardingTextField(
              controller: _monthController,
              focusNode: _monthFocus,
              hintText: 'MM',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              onChanged: (value) {
                setState(() {});
                _fieldFocusChange(value, 2, _monthFocus, _dayFocus);
              },
            ),
          ),
          Gaps.h16,
          divider,
          Gaps.h16,
          Expanded(
            flex: 3,
            child: OnboardingTextField(
              controller: _dayController,
              focusNode: _dayFocus,
              hintText: 'DD',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              onChanged: (value) {
                setState(() {});
                _fieldFocusChange(value, 2, _dayFocus, null);
              },
            ),
          ),
          Gaps.h16,
          Expanded(flex: 3, child: SizedBox()),
        ],
      ),
      guideText: S.of(context).birthdateGuideText,
      bottomButton: OnboardingButton(
        text: S.of(context).commonNext,
        onPressed: _handleNextPress,
        isEnabled: _isButtonEnabled,
      ),
    );
  }
}
