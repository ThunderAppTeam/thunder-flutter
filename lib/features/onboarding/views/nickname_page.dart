import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/time_const.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:thunder/features/auth/models/states/nickname_check_state.dart';
import 'package:thunder/features/auth/providers/nickname_check_provider.dart';
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
  bool _isButtonEnabled = true;

  void _onButtonPressed() async {
    setState(() {
      _isButtonEnabled = false;
    });
    final nickname = _controller.text;
    ref.read(nicknameCheckProvider.notifier).checkAvailability(nickname);
    Future.delayed(TimeConst.onboardingButtonCoolDown, () {
      setState(() {
        _isButtonEnabled = true;
      });
    });
  }

  bool _isValidNickname(String nickname) {
    //  공백 없음, 한글, 영어, 숫자만
    final regex = RegExp(r'^[a-zA-Z0-9가-힣]+$');
    return regex.hasMatch(nickname) &&
        !nickname.contains(' ') &&
        nickname.length >= 2;
  }

  void _onNicknameCheckStateChanged(
      NicknameCheckState? prev, NicknameCheckState next) {
    if (next.isAvailable) {
      final nickname = _controller.text;
      ref.read(onboardingProvider.notifier).setNickname(nickname);
      ref.read(onboardingProvider.notifier).pushNextStep(
            context: context,
            currentStep: OnboardingStep.nickname,
          );
    }
    if (prev?.error != next.error && next.error != null) {
      final String title, subtitle;
      switch (next.error!) {
        case NicknameCheckError.duplicated:
          title = S.of(context).nicknameErrorDuplicatedTitle;
          subtitle = S.of(context).nicknameErrorDuplicatedSubtitle;
          break;
        case NicknameCheckError.unknown:
          title = S.of(context).commonErrorUnknownTitle;
          subtitle = S.of(context).commonErrorUnknownSubtitle;
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(nicknameCheckProvider, _onNicknameCheckStateChanged);
    final isLoading = ref.watch(nicknameCheckProvider).isLoading;
    return PopScope(
      canPop: false,
      child: OnboardingScaffold(
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
          isEnabled: _isValidNickname(_controller.text) &&
              !isLoading &&
              _isButtonEnabled,
        ),
      ),
    );
  }
}
