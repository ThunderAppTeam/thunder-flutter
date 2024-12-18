import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:noon_body/core/formatters/phone_number_formatter.dart';
import 'package:noon_body/core/router/routes.dart';
import 'package:noon_body/core/theme/constants/gaps.dart';
import 'package:noon_body/core/theme/constants/sizes.dart';
import 'package:noon_body/core/theme/constants/styles.dart';
import 'package:noon_body/core/utils/theme_utils.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_button.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_scaffold.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_text_field.dart';

import 'package:noon_body/generated/l10n.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({super.key});

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  static const _minLength = 10;
  static const _maxLength = 12;

  final _controller = TextEditingController();
  bool get _isValid => _controller.text.length >= _minLength;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    return OnboardingScaffold(
      title: S.of(context).phoneNumberTitle,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 국가 코드
          Container(
            padding: const EdgeInsets.all(Sizes.spacing8),
            decoration: BoxDecoration(
              border: Border(
                bottom: Styles.whiteBorder2,
              ),
            ),
            child: Center(
              child: Text(
                S.of(context).phoneNumberFlagCode,
                style: textTheme.textTitle16,
              ),
            ),
          ),
          Gaps.h8,
          // 휴대폰 번호
          Expanded(
            child: OnboardingTextField(
              controller: _controller,
              hintText: S.of(context).phoneNumberInputHint,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(_maxLength),
                KoreanPhoneNumberFormatter(),
              ],
              canClear: true,
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
      guideText: S.of(context).phoneNumberGuideText,
      bottomButton: OnboardingButton(
        text: S.of(context).phoneNumberButton,
        onPressed: () => context.pushNamed(Routes.verification.name),
        isEnabled: _isValid,
      ),
    );
  }
}
