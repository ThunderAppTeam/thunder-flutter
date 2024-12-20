import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thunder/core/router/routes.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
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
  int _remainingSeconds = 180; // 3분 = 180초
  static const int _cooldownSeconds = 175; // 180 - 5 = 175초

  bool get _isValid => _controller.text.length == 6;
  bool get _canResend => _remainingSeconds <= _cooldownSeconds; // 5초 이하로 남았을 때

  @override
  void initState() {
    super.initState();
    _startTimer();

    if (Platform.isAndroid) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendVerificationCode();
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _remainingSeconds = 180);

    _timer = Timer.periodic(
      const Duration(seconds: 1),
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
    ref.read(authProvider.notifier).sendVerificationCode(phoneNumber);
  }

  String get _formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _onButtonPressed() {
    // TODO: 인증번호 검증 후 틀렸을 때 처리, 맞으면 닉네임 페이지로 이동
    context.pushNamed(Routes.nickname.name);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: _canResend
                    ? () {
                        _startTimer();
                      }
                    : null,
                isEnabled: _canResend,
              ),
            ],
          ),
        ],
      ),
      bottomButton: OnboardingButton(
        text: S.of(context).commonConfirm,
        onPressed: _onButtonPressed,
        isEnabled: _isValid,
      ),
    );
  }
}
