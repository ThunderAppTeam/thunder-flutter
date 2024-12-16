import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:noon_body/core/router/routes.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_button.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_scaffold.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _controller = TextEditingController();
  bool get _isValid => _controller.text.length == 6;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      title: '인증번호를\n입력해주세요',
      subtitle: '입력하신 휴대폰 번호로 인증번호를 전송했습니다',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            decoration: const InputDecoration(
              hintText: '인증번호 6자리 입력',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              // TODO: Implement resend verification code
            },
            child: const Text('인증번호 다시 받기'),
          ),
        ],
      ),
      bottomButton: OnboardingButton(
        text: '다음',
        onPressed: () => context.pushNamed(Routes.nickname.name),
        isEnabled: _isValid,
      ),
    );
  }
}
