import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:noon_body/core/router/routes.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_button.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_scaffold.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_text_field.dart';
import 'package:noon_body/generated/l10n.dart';

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
      title: S.of(context).nicknameTitle,
      content: OnboardingTextField(
        controller: _controller,
        hintText: S.of(context).nicknameHint,
        inputFormatters: [
          LengthLimitingTextInputFormatter(8),
        ],
        onChanged: (_) => setState(() {}),
        canClear: true,
      ),
      guideText: S.of(context).nicknameGuideText,
      bottomButton: OnboardingButton(
        text: S.of(context).commonNext,
        onPressed: () => context.pushNamed(Routes.birthdate.name),
        isEnabled: _isValid,
      ),
    );
  }
}
