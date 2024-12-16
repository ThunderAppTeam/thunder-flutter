import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:noon_body/core/router/routes.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_button.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_scaffold.dart';

class NicknamePage extends StatefulWidget {
  const NicknamePage({super.key});

  @override
  State<NicknamePage> createState() => _NicknamePageState();
}

class _NicknamePageState extends State<NicknamePage> {
  final _controller = TextEditingController();
  bool get _isValid => _controller.text.length >= 2;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      title: '닉네임을\n입력해주세요',
      subtitle: '다른 사용자들에게 보여질 이름입니다',
      content: TextFormField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: '닉네임 입력 (2-10자)',
        ),
        maxLength: 10,
        onChanged: (_) => setState(() {}),
      ),
      bottomButton: OnboardingButton(
        text: '다음',
        onPressed: () => context.pushNamed(Routes.birthdate.name),
        isEnabled: _isValid,
      ),
    );
  }
}
