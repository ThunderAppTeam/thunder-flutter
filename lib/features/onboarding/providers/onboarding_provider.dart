import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thunder/core/constants/time_consts.dart';
import 'package:thunder/core/enums/gender.dart';
import 'package:thunder/core/utils/info_utils.dart';
import 'package:thunder/features/auth/models/data/sign_up_user.dart';
import 'package:thunder/features/auth/providers/sign_up_provider.dart';
import 'package:thunder/features/onboarding/models/onboarding_state.dart';
import 'package:thunder/features/onboarding/views/birthdate_page.dart';
import 'package:thunder/features/onboarding/views/gender_page.dart';
import 'package:thunder/features/onboarding/views/nickname_page.dart';
import 'package:thunder/features/onboarding/views/phone_number_page.dart';
import 'package:thunder/features/onboarding/views/verification_page.dart';

enum OnboardingStep {
  phoneNumber,
  verification,
  nickname,
  birthdate,
  gender,
}

extension OnboardingStepX on OnboardingStep {
  Widget get page {
    return switch (this) {
      OnboardingStep.phoneNumber => const PhoneNumberPage(),
      OnboardingStep.verification => const VerificationPage(),
      OnboardingStep.nickname => const NicknamePage(),
      OnboardingStep.birthdate => const BirthdatePage(),
      OnboardingStep.gender => const GenderPage(),
    };
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  bool _isNavigating = false;
  bool get isNavigating => _isNavigating;

  final SignUpNotifier _signUpNotifier;

  OnboardingNotifier(this._signUpNotifier) : super(const OnboardingState());

  /// 다음 스탭으로 이동
  ///
  /// 오버엔지니어링을 막기 위해 현재 스텝을 이용하여 다음 페이지로 이동
  /// 더블 클릭 방지를 위해 네비게이션 중일 때는 무시
  void pushNextStep({
    required BuildContext context,
    required OnboardingStep currentStep,
  }) async {
    if (_isNavigating) return;
    _isNavigating = true;
    final nextStep = _getNextStep(currentStep);
    if (nextStep == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => nextStep.page,
      ),
    );
    await Future.delayed(TimeConsts.navigationDuration);
    _isNavigating = false;
  }

  OnboardingStep? _getNextStep(OnboardingStep step) {
    return switch (step) {
      OnboardingStep.phoneNumber => OnboardingStep.verification,
      OnboardingStep.verification => OnboardingStep.nickname,
      OnboardingStep.nickname => OnboardingStep.birthdate,
      OnboardingStep.birthdate => OnboardingStep.gender,
      OnboardingStep.gender => null,
    };
  }

  void setPhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void setNickname(String nickname) {
    state = state.copyWith(nickname: nickname);
  }

  void setBirthdate(DateTime birthdate) {
    state = state.copyWith(birthdate: birthdate);
  }

  void setGender(Gender gender) {
    state = state.copyWith(gender: gender);
  }

  void completeOnboarding({required bool marketingAgreed}) {
    final countryCode = getCountryCode();
    final signUpUser = SignUpUser(
      mobileNumber: state.phoneNumber!,
      countryCode: countryCode,
      mobileCountry: countryCode,
      gender: state.gender!.toJson(),
      birthDay: DateFormat('yyyy-MM-dd').format(state.birthdate!),
      marketingAgreement: marketingAgreed,
      nickname: state.nickname!,
    );
    _signUpNotifier.signUp(user: signUpUser);
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(ref.read(signUpProvider.notifier));
});
