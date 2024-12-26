import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/enums/gender.dart';
import 'package:thunder/core/extensions/gender_extension.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:thunder/features/onboarding/providers/onboarding_provider.dart';
import 'package:thunder/features/onboarding/views/widgets/gender_button.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_button.dart';
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

  bool get _isValid => _selectedGender != null;

  Future<void> _showTermsBottomSheet() async {
    showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => TermsBottomSheet(
        onAgree: (marketingAgreed) async {
          try {
            await ref
                .read(onboardingProvider.notifier)
                .completeOnboarding(marketingAgreed: marketingAgreed);
            if (context.mounted) {
              SafeRouter.goNamed(context, Routes.home.name);
            }
          } catch (e) {
            if (context.mounted) {
              showModalBottomSheet(
                context: context,
                builder: (context) => CustomBottomSheet(
                  title: S.of(context).termsErrorTitle,
                  subtitle: e.toString(),
                  buttonText: S.of(context).commonConfirm,
                ),
              );
            }
          }
        },
      ),
    );
  }

  void handleNextPress() {
    ref.read(onboardingProvider.notifier).setGender(_selectedGender!);
    _showTermsBottomSheet();
  }

  @override
  Widget build(BuildContext context) {
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
      bottomButton: OnboardingButton(
        text: S.of(context).commonConfirm,
        onPressed: handleNextPress,
        isEnabled: _isValid,
      ),
    );
  }
}
