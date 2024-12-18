import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:noon_body/core/router/routes.dart';
import 'package:noon_body/core/theme/constants/gaps.dart';
import 'package:noon_body/features/onboarding/views/widgets/gender_button.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_button.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_scaffold.dart';
import 'package:noon_body/generated/l10n.dart';
import 'package:noon_body/features/onboarding/views/widgets/bottom_sheets/terms_bottom_sheet.dart';

enum Gender {
  male,
  female,
}

class GenderPage extends StatefulWidget {
  const GenderPage({super.key});

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  Gender? _selectedGender;

  bool get _isValid => _selectedGender != null;

  Future<void> _showTermsBottomSheet() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => TermsBottomSheet(
        onAgreed: () {
          // 약관 동의 후 처리할 로직
          // 예: 사용자 정보 저장, 다음 페이지로 이동 등
        },
      ),
    );
    if (result == true) {
      context.go(Routes.home.path);
    }
  }

  void _handleNextPress() {
    _showTermsBottomSheet();
  }

  @override
  Widget build(BuildContext context) {
    final nickname = "썬더닉네임999";
    return OnboardingScaffold(
      title: S.of(context).genderTitle(nickname),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GenderButton(
            label: S.of(context).commonFemale,
            isSelected: _selectedGender == Gender.female,
            onTap: () => setState(() => _selectedGender = Gender.female),
          ),
          Gaps.v16,
          GenderButton(
            label: S.of(context).commonMale,
            isSelected: _selectedGender == Gender.male,
            onTap: () => setState(() => _selectedGender = Gender.male),
          ),
        ],
      ),
      bottomButton: OnboardingButton(
        text: S.of(context).commonConfirm,
        onPressed: _handleNextPress,
        isEnabled: _isValid,
      ),
    );
  }
}
