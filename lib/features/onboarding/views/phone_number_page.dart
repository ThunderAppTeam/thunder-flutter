import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thunder/core/formatters/phone_number_formatter.dart';
import 'package:thunder/core/router/routes.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/constants/styles.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/utils/validators.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:thunder/features/onboarding/providers/onboarding_provider.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_button.dart';
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

  String _formatToE164(String phoneNumber) {
    // 01012345678 -> +821012345678
    if (phoneNumber.startsWith('0')) {
      return '+82${phoneNumber.substring(1)}';
    }
    return '+82$phoneNumber';
  }

  void _onButtonPressed() {
    if (!Validators.isValidPhoneNumber(_phoneNumber)) {
      showModalBottomSheet(
        context: context,
        builder: (context) => CustomBottomSheet(
          title: "전화번호가 올바르지 않습니다.",
          buttonText: S.of(context).commonConfirm,
        ),
      );
      return;
    }
    final formattedPhoneNumber = _formatToE164(_phoneNumber);
    ref.read(onboardingProvider.notifier).setPhoneNumber(formattedPhoneNumber);
    context.pushNamed(Routes.verification.name);
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
              onChanged: (_) => setState(() {
                _phoneNumber = _controller.text.replaceAll('-', '');
              }),
            ),
          ),
        ],
      ),
      guideText: S.of(context).phoneNumberGuideText,
      bottomButton: OnboardingButton(
        text: S.of(context).phoneNumberButton,
        onPressed: _onButtonPressed,
        isEnabled: _isButtonEnabled,
      ),
    );
  }
}
