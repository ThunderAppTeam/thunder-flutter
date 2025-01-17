import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/features/auth/models/data/sign_up_user.dart';
import 'package:thunder/features/auth/models/states/sign_up_state.dart';
import 'package:thunder/features/auth/repositories/auth_repository.dart';

class SignUpNotifier extends StateNotifier<SignUpState> {
  SignUpNotifier(this._repository) : super(const SignUpState());

  final AuthRepository _repository;

  Future<void> signUp({
    required SignUpUser user,
  }) async {
    if (!mounted) return;
    state = state.copyWith(isLoading: true, isSuccess: false, isError: false);
    try {
      await _repository.signUp(user);
      log('signUp success');
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      log('signUp error: $e');
      state = state.copyWith(isLoading: false, isError: true);
    }
  }

  @override
  void dispose() {
    log('SignUpNotifier dispose');
    super.dispose();
  }
}

final signUpProvider =
    StateNotifierProvider<SignUpNotifier, SignUpState>((ref) {
  return SignUpNotifier(ref.read(authRepoProvider));
});
