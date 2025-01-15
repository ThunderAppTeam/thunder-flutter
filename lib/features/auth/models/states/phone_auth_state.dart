import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:thunder/core/errors/server_error.dart';

part 'phone_auth_state.freezed.dart';

@freezed
class PhoneAuthState with _$PhoneAuthState {
  const factory PhoneAuthState({
    @Default(false) bool isCodeSending,
    @Default(false) bool isTooManyMobileVerification,
    @Default(false) bool isCodeVerifying,
    @Default(false) bool isVerified,
    @Default(false) bool isExistUser,
    PhoneAuthError? error,
  }) = _PhoneAuthState;
}

enum PhoneAuthError {
  tooManyMobileVerification,
  notFoundMobileNumber,
  invalidVerificationCode,
  expiredVerificationCode,
  unknown;

  static PhoneAuthError fromServerError(ServerError errorCode) {
    switch (errorCode) {
      case ServerError.tooManyMobileVerification:
        return PhoneAuthError.tooManyMobileVerification;
      case ServerError.notFoundMobileNumber:
        return PhoneAuthError.notFoundMobileNumber;
      case ServerError.invalidMobileVerification:
        return PhoneAuthError.invalidVerificationCode;
      case ServerError.expiredMobileVerification:
        return PhoneAuthError.expiredVerificationCode;
      default:
        return PhoneAuthError.unknown;
    }
  }
}
