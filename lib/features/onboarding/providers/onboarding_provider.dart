import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/enums/gender.dart';
import 'package:thunder/core/utils/info_utils.dart';
import 'package:thunder/features/auth/models/data/sign_up_user.dart';
import 'package:thunder/features/auth/providers/sign_up_provider.dart';
import 'package:thunder/features/onboarding/models/onboarding_state.dart';

enum OnboardingStep {
  phoneNumber,
  verification,
  nickname,
  birthdate,
  gender,
}

extension OnboardingStepX on OnboardingStep {
  String get routeName {
    return switch (this) {
      OnboardingStep.phoneNumber => Routes.onboarding.phoneNumber.name,
      OnboardingStep.verification => Routes.onboarding.verification.name,
      OnboardingStep.nickname => Routes.onboarding.nickname.name,
      OnboardingStep.birthdate => Routes.onboarding.birthdate.name,
      OnboardingStep.gender => Routes.onboarding.gender.name,
    };
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final SafeRouter _safeRouter;
  final SignUpNotifier _signUpNotifier;

  OnboardingNotifier(this._safeRouter, this._signUpNotifier)
      : super(const OnboardingState());

  bool isDataValid() {
    // 현재 스텝에 해당하는 이전 정보가 기록되었어야함.
    switch (state.currentStep) {
      case OnboardingStep.phoneNumber:
        return true;
      case OnboardingStep.verification:
        return state.phoneNumber != null;
      case OnboardingStep.nickname:
        return state.isPhoneNumberVerified;
      case OnboardingStep.birthdate:
        return state.nickname != null;
      case OnboardingStep.gender:
        return state.birthdate != null;
    }
  }

  /// 다음 스탭으로 이동
  void pushNextStep({
    required BuildContext context,
    required OnboardingStep currentStep,
  }) async {
    final nextStep = _getNextStep(currentStep);
    if (nextStep == null) return;
    _safeRouter.pushNamed(context, nextStep.routeName);
    state = state.copyWith(currentStep: nextStep);
  }

  OnboardingStep? _getNextStep(OnboardingStep currentStep) {
    return switch (currentStep) {
      OnboardingStep.phoneNumber => OnboardingStep.verification,
      OnboardingStep.verification => OnboardingStep.nickname,
      OnboardingStep.nickname => OnboardingStep.birthdate,
      OnboardingStep.birthdate => OnboardingStep.gender,
      OnboardingStep.gender => null,
    };
  }

  void redirectToPhoneNumber() {
    state = state.copyWith(currentStep: OnboardingStep.phoneNumber);
  }

  void setPhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void setPhoneNumberVerified(bool isPhoneNumberVerified) {
    state = state.copyWith(isPhoneNumberVerified: isPhoneNumberVerified);
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
  return OnboardingNotifier(
    ref.read(safeRouterProvider),
    ref.read(signUpProvider.notifier),
  );
});
