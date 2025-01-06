import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/features/onboarding/providers/onboarding_provider.dart';
import 'package:thunder/core/widgets/buttons/custom_wide_button.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_scaffold.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_text_field.dart';
import 'package:thunder/generated/l10n.dart';

class NicknamePage extends ConsumerStatefulWidget {
  const NicknamePage({super.key});

  @override
  ConsumerState<NicknamePage> createState() => _NicknamePageState();
}

class _NicknamePageState extends ConsumerState<NicknamePage> {
  final _controller = TextEditingController();
  bool get _isValid => _controller.text.length >= 2;

  void _onButtonPressed() {
    final notifier = ref.read(onboardingProvider.notifier);
    notifier.setNickname(_controller.text);
    notifier.pushNextStep(
      context: context,
      currentStep: OnboardingStep.nickname,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      showBackButton: false,
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
      bottomButton: CustomWideButton(
        text: S.of(context).commonNext,
        onPressed: _onButtonPressed,
        isEnabled: _isValid,
      ),
    );
  }
}
