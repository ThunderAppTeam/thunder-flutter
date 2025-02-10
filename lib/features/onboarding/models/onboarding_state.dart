import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:thunder/core/enums/gender.dart';
import 'package:thunder/features/onboarding/providers/onboarding_provider.dart';

part 'onboarding_state.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    String? phoneNumber,
    @Default(false) bool isPhoneNumberVerified,
    String? nickname,
    DateTime? birthdate,
    Gender? gender,
    @Default(OnboardingStep.phoneNumber) OnboardingStep currentStep,
  }) = _OnboardingState;
}
