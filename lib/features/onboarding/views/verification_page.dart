import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:noon_body/core/router/routes.dart';
import 'package:noon_body/core/theme/constants/gaps.dart';
import 'package:noon_body/core/theme/constants/sizes.dart';
import 'package:noon_body/core/theme/constants/styles.dart';
import 'package:noon_body/core/theme/gen/colors.gen.dart';
import 'package:noon_body/core/utils/theme_utils.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_button.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_scaffold.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_text_field.dart';
import 'package:noon_body/generated/l10n.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _controller = TextEditingController();
  Timer? _timer;
  int _remainingSeconds = 180; // 3분 = 180초

  bool get _isValid => _controller.text.length == 6;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
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

  String get _formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
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
            onChanged: () => setState(() {}),
          ),
          Gaps.v16,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(Sizes.spacing8),
                decoration: BoxDecoration(
                  color: ColorName.white,
                  borderRadius: BorderRadius.circular(Styles.radius4),
                ),
                child: Text(
                  '인증문자 다시 받기',
                  style: textTheme.textSubtitle12.copyWith(
                    color: ColorName.black.withOpacity(Styles.opacity70),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomButton: OnboardingButton(
        text: '확인',
        onPressed: () => context.pushNamed(Routes.nickname.name),
        isEnabled: _isValid,
      ),
    );
  }
}
