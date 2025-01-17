import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/time_consts.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:thunder/features/auth/models/states/phone_auth_state.dart';
import 'package:thunder/features/auth/providers/phone_auth_provider.dart';
import 'package:thunder/features/onboarding/controllers/verification_controller.dart';

import 'package:thunder/core/widgets/buttons/custom_wide_button.dart';
import 'package:thunder/features/onboarding/providers/onboarding_provider.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_scaffold.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_small_button.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_text_field.dart';
import 'package:thunder/generated/l10n.dart';

class VerificationPage extends ConsumerStatefulWidget {
  const VerificationPage({super.key});

  @override
  ConsumerState<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends ConsumerState<VerificationPage> {
  final _textController = TextEditingController();
  late final VerificationTimerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ref.read(verificationTimerProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.init();
    });
  }

  String _formattedTime(int seconds) {
    final minutes = seconds ~/ TimeConsts.minute;
    final remainingSeconds = seconds % TimeConsts.minute;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _onResendPressed() {
    _controller.resendVerificationCode();
  }

  void _onVerifyPressed() async {
    final smsCode = _textController.text;
    _controller.verifyCode(smsCode);
  }

  void _onVerifySuccess(bool isExistUser) {
    ref.invalidate(verificationTimerProvider);
    if (isExistUser) {
      ref.invalidate(onboardingProvider);
      ref.read(safeRouterProvider).goToHome(context);
    } else {
      ref.read(onboardingProvider.notifier).pushNextStep(
            context: context,
            currentStep: OnboardingStep.verification,
          );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onPhoneAuthStateChanged(PhoneAuthState? prev, PhoneAuthState next) {
    if (next.isVerified) {
      _onVerifySuccess(next.isExistUser);
    }
    if (prev?.error != next.error && next.error != null) {
      final String title, subtitle;
      switch (next.error!) {
        case PhoneAuthError.tooManyMobileVerification:
          title = S.of(context).verificationErrorTooManyMobileVerificationTitle;
          subtitle =
              S.of(context).verificationErrorTooManyMobileVerificationSubtitle;
          break;
        case PhoneAuthError.notFoundMobileNumber:
          title = S.of(context).verificationErrorNotFoundMobileNumberTitle;
          subtitle =
              S.of(context).verificationErrorNotFoundMobileNumberSubtitle;
          break;
        case PhoneAuthError.invalidVerificationCode:
          title = S.of(context).verificationErrorInvalidVerificationCodeTitle;
          subtitle =
              S.of(context).verificationErrorInvalidVerificationCodeSubtitle;
          break;
        case PhoneAuthError.unknown:
          title = S.of(context).commonErrorUnknownTitle;
          subtitle = S.of(context).commonErrorUnknownSubtitle;
          break;
        case PhoneAuthError.expiredVerificationCode:
          title = "인증 코드가 만료되었습니다.";
          subtitle = "인증 코드를 다시 발송해주세요.";
          break;
      }
      showModalBottomSheet(
        context: context,
        builder: (context) => CustomBottomSheet(
          title: title,
          subtitle: subtitle,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(phoneAuthProvider, _onPhoneAuthStateChanged);
    final timerState = ref.watch(verificationTimerProvider);
    final phoneAuthState = ref.watch(phoneAuthProvider);

    final isResendEnabled = !phoneAuthState.isTooManyMobileVerification &&
        !phoneAuthState.isCodeSending &&
        timerState.canSend;

    final isVerifyEnabled = _textController.text.length == 6 &&
        timerState.canVerify &&
        !phoneAuthState.isCodeVerifying &&
        !ref.read(safeRouterProvider).isNavigating;

    return OnboardingScaffold(
      title: S.of(context).verificationTitle,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OnboardingTextField(
            controller: _textController,
            hintText: S.of(context).verificationHint,
            suffixText: _formattedTime(timerState.remainingSeconds),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            canClear: true,
            onChanged: (_) => setState(() {}),
          ),
          Gaps.v16,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              OnboardingSmallButton(
                text: S.of(context).verificationResend,
                onPressed: _onResendPressed,
                isEnabled: isResendEnabled,
              ),
            ],
          ),
        ],
      ),
      bottomButton: CustomWideButton(
        text: S.of(context).commonConfirm,
        onPressed: _onVerifyPressed,
        isEnabled: isVerifyEnabled,
      ),
    );
  }
}
