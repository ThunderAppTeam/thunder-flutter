import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/enums/gender.dart';
import 'package:thunder/features/auth/repositories/auth_repository.dart';
import 'package:thunder/features/onboarding/models/onboarding_state.dart';
import 'package:thunder/features/users/models/user_profile.dart';
import 'package:thunder/features/users/repositories/user_repository.dart';

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final AuthRepository _authRepo;
  final UserRepository _userRepo;

  OnboardingNotifier({
    required AuthRepository authRepo,
    required UserRepository userRepo,
  })  : _authRepo = authRepo,
        _userRepo = userRepo,
        super(const OnboardingState());

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
    if (user == null) throw Exception('User not found');
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
