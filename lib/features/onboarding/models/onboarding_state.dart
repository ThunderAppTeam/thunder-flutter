import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:thunder/core/enums/gender.dart';

part 'onboarding_state.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    String? phoneNumber,
    String? nickname,
    DateTime? birthdate,
    Gender? gender,
  }) = _OnboardingState;
}
