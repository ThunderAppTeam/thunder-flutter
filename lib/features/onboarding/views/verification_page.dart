import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/time_consts.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:thunder/features/auth/models/auth_state.dart';
import 'package:thunder/features/auth/providers/auth_view_model.dart';
import 'package:thunder/features/onboarding/providers/onboarding_provider.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_button.dart';
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
  final _controller = TextEditingController();
  Timer? _timer;
  int _remainingSeconds = TimeConsts.verificationTimeLimit;
  bool get _isValid => _controller.text.length == 6 && _remainingSeconds > 0;
  bool get _canResend {
    return _remainingSeconds <=
        TimeConsts.verificationTimeLimit - TimeConsts.verificationResendDelay;
  }

  bool get _isVerifying =>
      ref.watch(authProvider).status == AuthStatus.verifying;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendVerificationCode();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _remainingSeconds = TimeConsts.verificationTimeLimit);
    _timer = Timer.periodic(
      TimeConsts.duration1s,
      (timer) {
        if (_remainingSeconds == 0) {
          timer.cancel();
        } else {
          setState(() {
            _remainingSeconds--;
          });
        }
      },
    );
  }

  void _sendVerificationCode() {
    final phoneNumber = ref.read(onboardingProvider).phoneNumber!;
    ref.read(authProvider.notifier).executeSendVerificationCode(phoneNumber);
  }

  String get _formattedTime {
    final minutes = _remainingSeconds ~/ TimeConsts.minute;
    final seconds = _remainingSeconds % TimeConsts.minute;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _onResendPressed() {
    _startTimer();
    _sendVerificationCode();
  }

  void _onButtonPressed() async {
    final smsCode = _controller.text;
    ref.read(authProvider.notifier).executeVerifyCode(smsCode);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onAuthStateChanged(AuthState? prev, AuthState next) {
    switch (next.status) {
      case AuthStatus.verified:
        _controller.clear();
        final notifier = ref.read(onboardingProvider.notifier);
        notifier.pushNextStep(
          context: context,
          currentStep: OnboardingStep.verification,
        );
        break;
      case AuthStatus.failed:
        if (next.failureReason != null) {
          showModalBottomSheet(
            context: context,
            builder: (context) => CustomBottomSheet(
              title: "인증 실패",
              subtitle: switch (next.failureReason!) {
                AuthFailureReason.reCaptchaVerificationFailed =>
                  "reCAPTCHA 검증을 취소했습니다. 인증문자를 발송하고 다시 시도해주세요.",
                AuthFailureReason.invalidPhoneNumber =>
                  "유효하지 않은 전화번호입니다. 전화번호를 다시 확인해주세요.",
                AuthFailureReason.invalidSmsCode =>
                  "인증번호가 일치하지 않습니다. 다시 입력해주세요.",
                AuthFailureReason.quotaExceeded =>
                  "인증번호 발송 횟수가 초과되었습니다. 기다린 후 다시 시도해주세요.",
                AuthFailureReason.timeout => "인증번호 입력 시간이 초과되었습니다. 다시 시도해주세요.",
                AuthFailureReason.codeNotSent => "인증번호가 발송되지 않았습니다. 다시 시도해주세요.",
                AuthFailureReason.unknown => "알 수 없는 오류가 발생했습니다. 다시 시도해주세요.",
              },
            ),
          );
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, _onAuthStateChanged);
    return OnboardingScaffold(
      title: S.of(context).verificationTitle,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OnboardingTextField(
            controller: _controller,
            hintText: S.of(context).verificationHint,
            suffixText: _formattedTime,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            autofocus: true,
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
                isEnabled: _canResend,
              ),
            ],
          ),
        ],
      ),
      bottomButton: OnboardingButton(
        text: S.of(context).commonConfirm,
        onPressed: _onButtonPressed,
        isEnabled: _isValid && !_isVerifying && !SafeRouter.isNavigating,
      ),
    );
  }
}
