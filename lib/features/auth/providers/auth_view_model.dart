import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/features/auth/models/auth_state.dart';
import 'package:thunder/features/auth/repositories/auth_repository.dart';

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _authRepo;

  AuthViewModel(this._authRepo) : super(const AuthState());

  Future<void> executeSendVerificationCode(String phoneNumber) async {
    state = state.copyWith(
      status: AuthStatus.codeSending,
    );
    try {
      await _authRepo.sendVerificationCode(
        phoneNumber: phoneNumber,
        onAutoVerified: (smsCode) {
          state = state.copyWith(
            status: AuthStatus.autoVerified,
            smsCode: smsCode,
          );
        },
        onFailed: (reason) {
          state = state.copyWith(
            status: AuthStatus.failed,
            failureReason: reason,
          );
        },
        onCodeSent: (verificationId) {
          state = state.copyWith(
            status: AuthStatus.codeSent,
            verificationId: verificationId,
          );
        },
      );
    } catch (err) {
      state = state.copyWith(
        status: AuthStatus.failed,
        failureReason: AuthFailureReason.unknown,
      );
    }
  }

  Future<void> executeVerifyCode(String smsCode) async {
    state = state.copyWith(
      status: AuthStatus.verifying,
    );
    if (state.verificationId == null) {
      state = state.copyWith(
        status: AuthStatus.failed,
        failureReason: AuthFailureReason.codeNotSent,
      );
      return;
    }
    try {
      await _authRepo.verifyCode(
        state.verificationId!,
        smsCode,
      );
      state = state.copyWith(status: AuthStatus.verified);
    } catch (err) {
      // 확인된 에러: 1. 인증번호 불일치
      state = state.copyWith(
        status: AuthStatus.failed,
        failureReason: AuthFailureReason.invalidSmsCode,
      );
    }
  }
}

final authProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final authRepo = ref.watch(authRepoProvider);
  return AuthViewModel(authRepo);
});
