import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:noon_body/core/router/routes.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_button.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_scaffold.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({super.key});

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final _controller = TextEditingController();
  bool get _isValid => _controller.text.length >= 10;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      title: '휴대폰 번호를\n입력해주세요',
      content: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
        ],
        decoration: const InputDecoration(
          hintText: '휴대폰 번호 입력',
          prefixText: '+82 ',
        ),
        onChanged: (_) => setState(() {}),
      ),
      bottomButton: OnboardingButton(
        text: '인증번호 받기',
        onPressed: () => context.pushNamed(Routes.verification.name),
        isEnabled: _isValid,
      ),
    );
  }
}
