import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/enums/gender.dart';
import 'package:thunder/features/onboarding/models/onboarding_state.dart';

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier()
      : super(const OnboardingState(
          nickname: 'Default',
        ));

  void setPhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void setNickname(String nickname) {
    state = state.copyWith(nickname: nickname);
  }

  void setBirthday(DateTime birthday) {
    state = state.copyWith(birthday: birthday);
  }

  void setGender(Gender gender) {
    state = state.copyWith(gender: gender);
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});
