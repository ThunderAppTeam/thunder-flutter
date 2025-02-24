enum ServerError {
  unknown("UNKNOWN"),
  invalidResponse("INVALID_RESPONSE"),
  unknownServerError("UNKNOWN_SERVER_ERROR"),
  missingRequiredParameter("MISSING_REQUIRED_PARAMETER"),
  invalidParameterValue("INVALID_PARAMETER_VALUE"),

  notFoundMobileVerification("NOT_FOUND_MOBILE_VERIFICATION"),
  expiredMobileVerification("EXPIRED_MOBILE_VERIFICATION"),
  invalidMobileVerification("INVALID_MOBILE_VERIFICATION"),
  tooManyMobileVerification("TOO_MANY_MOBILE_VERIFICATION"),
  notFoundMobileNumber("NOT_FOUND_MOBILE_NUMBER"),
  sendSmsApiError("SEND_SMS_API_ERROR"),

  expiredToken("EXPIRED_TOKEN"),
  invalidToken("INVALID_TOKEN"),
  invalidAuthorizationHeader("INVALID_AUTHORIZATION_HEADER"),

  notFoundMember("NOT_FOUND_MEMBER"),
  nicknameDuplicated("NICKNAME_DUPLICATED"),
  mobileNumberDuplicated("MOBILE_NUMBER_DUPLICATED"),

  unsupportedImageFormat("UNSUPPORTED_IMAGE_FORMAT"),
  notFoundBodyPhoto("NOT_FOUND_BODY_PHOTO"),
  alreadyReviewed("ALREADY_REVIEWED"),
  alreadyFlagged("ALREADY_FLAGGED"),
  uploaderOrAdminOnlyAccess("UPLOADER_OR_ADMIN_ONLY_ACCESS"),

  bodyNotDetectedInPhoto("BODY_NOT_DETECTED_IN_PHOTO");

  const ServerError(this.code);

  final String code;

  static final Map<String, ServerError> _map = {
    for (var e in values) e.code: e
  };

  static ServerError fromString(String code) =>
      _map[code] ?? ServerError.unknown;
}

// UNKNOWN_SERVER_ERROR(INTERNAL_SERVER_ERROR, "An unknown error occurred on the server."),
// MISSING_REQUIRED_PARAMETER(BAD_REQUEST, "Invalid request body format."),
// INVALID_PARAMETER_VALUE(BAD_REQUEST, "Invalid request body format."),

// NOT_FOUND_MOBILE_VERIFICATION(BAD_REQUEST, "Verification code not sent to this mobile number."),
// EXPIRED_MOBILE_VERIFICATION(BAD_REQUEST, "Verification code is expired."),
// INVALID_MOBILE_VERIFICATION(BAD_REQUEST, "Invalid mobile verification code."),
// TOO_MANY_MOBILE_VERIFICATION(TOO_MANY_REQUESTS, "Mobile verification can only be requested 5 times per day."),

// NOT_FOUND_MOBILE_NUMBER(BAD_REQUEST, "Not found mobile number."),
// SEND_SMS_API_ERROR(INTERNAL_SERVER_ERROR, "Failed to send SMS due to an error in the external SMS service."),

// EXPIRED_TOKEN(UNAUTHORIZED, "The token has expired."),
// INVALID_TOKEN(UNAUTHORIZED, "The token is invalid."),
// INVALID_AUTHORIZATION_HEADER(BAD_REQUEST, "Authorization header must include Bearer prefix."),

// NOT_FOUND_MEMBER(NOT_FOUND, "Member not found"),
// NICKNAME_DUPLICATED(CONFLICT, "Nickname already exists."),
// MOBILE_NUMBER_DUPLICATED(CONFLICT, "This mobile number is already registered."),

// UNSUPPORTED_IMAGE_FORMAT(BAD_REQUEST, "Only JPG and PNG formats are allowed for image."),
// NOT_FOUND_BODY_PHOTO(NOT_FOUND, "Body Photo not found."),
// ALREADY_REVIEWED(CONFLICT, "Body Photo has already been reviewed by same member."),
// ALREADY_FLAGGED(CONFLICT, "Body Photo has already been flagged by same member."),
// UPLOADER_OR_ADMIN_ONLY_ACCESS(FORBIDDEN, "Only uploader or admin has permission for this request."),
// BODY_NOT_DETECTED_IN_PHOTO