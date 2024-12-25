import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/time_consts.dart';
import 'package:thunder/core/enums/gender.dart';
import 'package:thunder/features/auth/repositories/auth_repository.dart';
import 'package:thunder/features/onboarding/models/onboarding_state.dart';
import 'package:thunder/features/onboarding/views/birthdate_page.dart';
import 'package:thunder/features/onboarding/views/gender_page.dart';
import 'package:thunder/features/onboarding/views/nickname_page.dart';
import 'package:thunder/features/onboarding/views/phone_number_page.dart';
import 'package:thunder/features/onboarding/views/verification_page.dart';
import 'package:thunder/features/onboarding/views/welcome_page.dart';

import 'package:thunder/features/users/models/user_profile.dart';
import 'package:thunder/features/users/repositories/user_repository.dart';

enum OnboardingStep {
  welcome,
  phoneNumber,
  verification,
  nickname,
  birthdate,
  gender,
}

extension OnboardingStepX on OnboardingStep {
  Widget get page {
    return switch (this) {
      OnboardingStep.welcome => const WelcomePage(),
      OnboardingStep.phoneNumber => const PhoneNumberPage(),
      OnboardingStep.verification => const VerificationPage(),
      OnboardingStep.nickname => const NicknamePage(),
      OnboardingStep.birthdate => const BirthdatePage(),
      OnboardingStep.gender => const GenderPage(),
    };
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final AuthRepository _authRepo;
  final UserRepository _userRepo;

  bool _isNavigating = false;
  bool get isNavigating => _isNavigating;

  OnboardingNotifier({
    required AuthRepository authRepo,
    required UserRepository userRepo,
  })  : _authRepo = authRepo,
        _userRepo = userRepo,
        super(const OnboardingState());

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
    await Future.delayed(
        const Duration(milliseconds: TimeConsts.navigationDelay));
    _isNavigating = false;
  }

  OnboardingStep? _getNextStep(OnboardingStep step) {
    return switch (step) {
      OnboardingStep.welcome => OnboardingStep.phoneNumber,
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

  Future<void> completeOnboarding({required bool marketingAgreed}) async {
    state = state.copyWith(isLoading: true);
    final user = _authRepo.currentUser;
    if (user == null) {
      state = state.copyWith(isLoading: false);
      throw Exception('User not found');
    }
    try {
      final profile = UserProfile(
        uid: user.uid,
        phoneNumber: user.phoneNumber!, // 국가 코드 포함
        nickname: state.nickname!,
        gender: state.gender!,
        birthdate: state.birthdate!,
        marketingAgreed: marketingAgreed,
        createdAt: DateTime.now().microsecondsSinceEpoch,
      );
      await _userRepo.createUserProfile(profile);
    } catch (e) {
      log('Error creating user profile: $e');
      throw Exception('Failed to create user profile');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(
    authRepo: ref.read(authRepoProvider),
    userRepo: ref.read(userRepoProvider),
  );
});
