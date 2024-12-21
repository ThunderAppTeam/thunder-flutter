import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/features/auth/repositories/auth_repository.dart';

class AuthViewModel extends AsyncNotifier<String?> {
  String? _verificationId;

  @override
  Future<String?> build() async {
    return null;
  }

  Future<void> sendVerificationCode(String phoneNumber) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      _verificationId = await repository.sendVerificationCode(phoneNumber);
      return _verificationId;
    });
    if (state.hasError) {
      log('Failed to send verification code ${state.error}');
    }
  }

  Future<bool> verifyCode(String smsCode) async {
    if (_verificationId == null) return false;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      final success = await repository.verifyCode(_verificationId!, smsCode);
      if (!success) throw Exception('Invalid verification code');
      return _verificationId;
    });
    return !state.hasError;
  }
}

final authProvider = AsyncNotifierProvider<AuthViewModel, String?>(() {
  return AuthViewModel();
});
