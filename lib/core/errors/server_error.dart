enum ServerError {
  // 에러 코드에 따른 에러
  unknown,
  missingRequiredParameter,
  invalidParameterValue,

  // mobile verification
  notFoundMobileVerification,
  expiredMobileVerification,
  invalidMobileVerification,
  tooManyMobileVerification,
  notFoundMobileNumber,

  // nickname
  nicknameDuplicated,

  // token
  expiredToken,
  invalidToken,
  invalidAuthorizationHeader,
  notFoundMember,
  unsupportedImageFormat,

  // 응답 이후 에러
  invalidResponse,
}

class ServerErrorCode {
  static const unknownServerError = 'UNKNOWN_SERVER_ERROR';
  static const missingRequiredParameter = 'MISSING_REQUIRED_PARAMETER';
  static const invalidParameterValue = 'INVALID_PARAMETER_VALUE';

  static const notFoundMobileVerification = 'NOT_FOUND_MOBILE_VERIFICATION';
  static const expiredMobileVerification = 'EXPIRED_MOBILE_VERIFICATION';
  static const invalidMobileVerification = 'INVALID_MOBILE_VERIFICATION';
  static const tooManyMobileVerification = 'TOO_MANY_MOBILE_VERIFICATION';
  static const nicknameDuplicated = 'NICKNAME_DUPLICATED';

  static const expiredToken = 'EXPIRED_TOKEN';
  static const invalidToken = 'INVALID_TOKEN';
  static const invalidAuthorizationHeader = 'INVALID_AUTHORIZATION_HEADER';

  static const notFoundMember = 'NOT_FOUND_MEMBER';

  static const unsupportedImageFormat = 'UNSUPPORTED_IMAGE_FORMAT';

  static const notFoundMobileNumber = 'NOT_FOUND_MOBILE_NUMBER';
}

extension ServerErrorX on ServerError {
  static ServerError fromString(String code) {
    switch (code) {
      case ServerErrorCode.unknownServerError:
        return ServerError.unknown;
      case ServerErrorCode.missingRequiredParameter:
        return ServerError.missingRequiredParameter;
      case ServerErrorCode.invalidParameterValue:
        return ServerError.invalidParameterValue;
      case ServerErrorCode.notFoundMobileVerification:
        return ServerError.notFoundMobileVerification;
      case ServerErrorCode.expiredMobileVerification:
        return ServerError.expiredMobileVerification;
      case ServerErrorCode.invalidMobileVerification:
        return ServerError.invalidMobileVerification;
      case ServerErrorCode.tooManyMobileVerification:
        return ServerError.tooManyMobileVerification;
      case ServerErrorCode.nicknameDuplicated:
        return ServerError.nicknameDuplicated;
      case ServerErrorCode.expiredToken:
        return ServerError.expiredToken;
      case ServerErrorCode.invalidToken:
        return ServerError.invalidToken;
      case ServerErrorCode.invalidAuthorizationHeader:
        return ServerError.invalidAuthorizationHeader;
      case ServerErrorCode.notFoundMember:
        return ServerError.notFoundMember;
      case ServerErrorCode.unsupportedImageFormat:
        return ServerError.unsupportedImageFormat;
      case ServerErrorCode.notFoundMobileNumber:
        return ServerError.notFoundMobileNumber;
      default:
        return ServerError.unknown;
    }
  }
}
