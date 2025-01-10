import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/enums/gender.dart';
import 'package:thunder/core/extensions/gender_extension.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:thunder/features/auth/models/domain/sign_up_state.dart';
import 'package:thunder/features/auth/providers/sign_up_provider.dart';
import 'package:thunder/features/onboarding/providers/onboarding_provider.dart';
import 'package:thunder/features/onboarding/views/widgets/gender_button.dart';
import 'package:thunder/core/widgets/buttons/custom_wide_button.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_scaffold.dart';
import 'package:thunder/generated/l10n.dart';
import 'package:thunder/features/onboarding/views/widgets/bottom_sheets/terms_bottom_sheet.dart';

class GenderPage extends ConsumerStatefulWidget {
  const GenderPage({super.key});

  @override
  ConsumerState<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends ConsumerState<GenderPage> {
  Gender? _selectedGender;
  bool _isTermButtonEnabled = true;
  bool get _isValid => _selectedGender != null;

  Future<void> _showTermsBottomSheet() async {
    showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => TermsBottomSheet(
        isButtonEnabled: _isTermButtonEnabled,
        onAgree: _onAgree,
      ),
    );
  }

  void _onAgree(bool marketingAgreed) {
    ref
        .read(onboardingProvider.notifier)
        .completeOnboarding(marketingAgreed: marketingAgreed);
  }

  void _handleNextPress() {
    ref.read(onboardingProvider.notifier).setGender(_selectedGender!);
    _showTermsBottomSheet();
  }

  void _onSignUpStateChange(SignUpState? prev, SignUpState next) {
    if (next.isSuccess) {
      ref.read(safeRouterProvider).goNamed(context, Routes.home.name);
    } else if (prev?.isError != next.isError && next.isError) {
      showModalBottomSheet(
        context: context,
        builder: (context) => CustomBottomSheet(
          title: S.of(context).commonErrorUnknownTitle,
          subtitle: S.of(context).commonErrorUnknownSubtitle,
        ),
      );
    }
    if (next.isLoading) {
      setState(() {
        _isTermButtonEnabled = false;
      });
    } else {
      setState(() {
        _isTermButtonEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signUpProvider, _onSignUpStateChange);
    final nickname = ref.read(onboardingProvider).nickname!;
    return OnboardingScaffold(
      title: S.of(context).genderTitle(nickname),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GenderButton(
            label: Gender.female.toDisplayString(context),
            isSelected: _selectedGender == Gender.female,
            onTap: () => setState(() => _selectedGender = Gender.female),
          ),
          Gaps.v16,
          GenderButton(
            label: Gender.male.toDisplayString(context),
            isSelected: _selectedGender == Gender.male,
            onTap: () => setState(() => _selectedGender = Gender.male),
          ),
        ],
      ),
      bottomButton: CustomWideButton(
        text: S.of(context).commonConfirm,
        onPressed: _handleNextPress,
        isEnabled: _isValid,
      ),
    );
  }
}
