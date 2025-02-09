import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/analytics_const.dart';
import 'package:thunder/core/enums/gender.dart';
import 'package:thunder/core/services/analytics_service.dart';
import 'package:thunder/features/auth/models/data/sign_up_user.dart';
import 'package:thunder/features/auth/models/data/user_property_data.dart';
import 'package:thunder/features/auth/models/states/sign_up_state.dart';
import 'package:thunder/features/auth/providers/auth_state_provider.dart';
import 'package:thunder/features/auth/repositories/auth_repository.dart';

class SignUpNotifier extends StateNotifier<SignUpState> {
  SignUpNotifier(this._repository, this._authNotifier)
      : super(const SignUpState());

  final AuthRepository _repository;
  final AuthNotifier _authNotifier;

  Future<void> signUp({
    required SignUpUser user,
  }) async {
    state = state.copyWith(isLoading: true, isSuccess: false, isError: false);
    try {
      final data = await _repository.signUp(user);
      final userPropertyData = UserPropertyData.fromJson(data);
      _authNotifier.login(userPropertyData.memberUuid);
      AnalyticsService.signUp();
      final genderValue = userPropertyData.gender == GenderConsts.male
          ? AnalyticsValue.gender.male
          : AnalyticsValue.gender.female;
      AnalyticsService.setUserProperties(
        gender: genderValue,
        age: userPropertyData.age,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, isError: true);
    }
  }
}

final signUpProvider =
    StateNotifierProvider<SignUpNotifier, SignUpState>((ref) {
  return SignUpNotifier(
    ref.read(authRepositoryProvider),
    ref.read(authStateProvider.notifier),
  );
});
