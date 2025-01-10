import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_auth_state.freezed.dart';

@freezed
class PhoneAuthState with _$PhoneAuthState {
  const factory PhoneAuthState({
    @Default(false) bool isCodeSending,
    @Default(false) bool isTooManyMobileVerification,
    @Default(false) bool isCodeVerifying,
    @Default(false) bool isVerified,
    PhoneAuthError? error,
  }) = _PhoneAuthState;
}

class PhoneAuthExceptionCode {
  static const tooManyMobileVerification = 'TOO_MANY_MOBILE_VERIFICATION';
  static const notFoundMobileNumber = 'NOT_FOUND_MOBILE_NUMBER';
  static const invalidVerificationCode = 'INVALID_MOBILE_VERIFICATION';
}

enum PhoneAuthError {
  tooManyMobileVerification,
  notFoundMobileNumber,
  invalidVerificationCode,
  unknown;

  static PhoneAuthError fromString(String errorCode) {
    switch (errorCode) {
      case PhoneAuthExceptionCode.tooManyMobileVerification:
        return PhoneAuthError.tooManyMobileVerification;
      case PhoneAuthExceptionCode.notFoundMobileNumber:
        return PhoneAuthError.notFoundMobileNumber;
      case PhoneAuthExceptionCode.invalidVerificationCode:
        return PhoneAuthError.invalidVerificationCode;
      default:
        return PhoneAuthError.unknown;
    }
  }
}
