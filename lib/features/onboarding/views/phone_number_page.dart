import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/formatters/phone_number_formatter.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/constants/styles.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/utils/validators.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:thunder/features/onboarding/providers/onboarding_provider.dart';
import 'package:thunder/core/widgets/buttons/custom_wide_button.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_scaffold.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_text_field.dart';

import 'package:thunder/generated/l10n.dart';

class PhoneNumberPage extends ConsumerStatefulWidget {
  const PhoneNumberPage({super.key});

  @override
  ConsumerState<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends ConsumerState<PhoneNumberPage> {
  static const _minLength = 11;
  static const _maxLength = 11;

  final _controller = TextEditingController();

  String _phoneNumber = ''; // - 없는 숫자만 있는 전화번호

  bool get _isButtonEnabled => _phoneNumber.length >= _minLength;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onButtonPressed() {
    if (!Validators.isValidPhoneNumber(_phoneNumber)) {
      showModalBottomSheet(
        context: context,
        builder: (context) => CustomBottomSheet(
          title: S.of(context).phoneNumberErrorTitle,
          subtitle: S.of(context).phoneNumberErrorSubtitle,
          buttonText: S.of(context).commonConfirm,
        ),
      );
      return;
    }
    final notifier = ref.read(onboardingProvider.notifier);
    notifier.setPhoneNumber(_phoneNumber);
    notifier.pushNextStep(
      context: context,
      currentStep: OnboardingStep.phoneNumber,
    );
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
              autofocus: true,
              canClear: true,
              onChanged: (_) => setState(() {
                _phoneNumber = _controller.text.replaceAll('-', '');
              }),
            ),
          ),
        ],
      ),
      guideText: S.of(context).phoneNumberGuideText,
      bottomButton: CustomWideButton(
        text: S.of(context).phoneNumberButton,
        onPressed: _onButtonPressed,
        isEnabled: _isButtonEnabled,
      ),
    );
  }
}
