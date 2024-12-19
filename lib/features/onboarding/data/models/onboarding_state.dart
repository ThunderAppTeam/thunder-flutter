import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:thunder/features/user/models/user_profile.dart';

part 'onboarding_state.freezed.dart';

enum OnboardingStep {
  start,
  phoneNumber,
  verification,
  nickname,
  birthday,
  gender
}

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(OnboardingStep.start) OnboardingStep currentStep,
    @Default(UserProfile()) UserProfile user,
    @Default(false) bool isLoading,
    String? error,
  }) = _OnboardingState;
}
