import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

class AuthExceptionCode {
  static const webContextCancelled = 'web-context-cancelled'; // reCAPTCHA 검증 취소
  static const invalidPhoneNumber = 'invalid-phone-number';
  static const quotaExceeded = 'quota-exceeded';
}

enum AuthStatus {
  initial,
  codeSending,
  autoVerified,
  codeSent,
  verifying,
  verified,
  failed,
}

enum AuthFailureReason {
  invalidPhoneNumber,
  quotaExceeded,
  timeout,
  codeNotSent,
  invalidSmsCode,
  reCaptchaVerificationFailed,
  unknown,
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    String? verificationId,
    String? smsCode,
    AuthFailureReason? failureReason,
  }) = _AuthState;
}
