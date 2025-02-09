class AnalyticsEvent {
  // Auth Events
  static const String authPhoneStart = 'auth_phone_start';
  static const String authPhone = 'auth_phone';
  static const String login = 'login';
  static const String signUpStart = 'sign_up_start';
  static const String signUp = 'sign_up';
  static const String logout = 'logout';
  static const String deleteAccount = 'delete_account';

  // Content Events
  static const String reviewBody = 'review_body';
  static const String tapTab = 'tap_tab';
  static const String selectPhoto = 'select_photo';
  static const String uploadPhoto = 'upload_photo';
  static const String viewBodyResult = 'view_body_result';
  static const String share = 'share';
  static const String deleteContent = 'delete_content';
  static const String reportContent = 'report_content';
  static const String blockUser = 'block_user';
}

class AnalyticsParam {
  static const String method = 'method';

  // Content Parameters
  static const String reviewedContent = 'reviewed_content';
  static const String reviewScore = 'review_score';
  static const String tabName = 'tab_name';
  static const String photoSource = 'photo_source';
  static const String viewedContentId = 'viewed_content_id';
  static const String contentType = 'content_type';
  static const String itemId = 'item_id';
  static const String deletedContentId = 'deleted_content_id';
  static const String reportedContentId = 'reported_content_id';
  static const String blockedUserId = 'blocked_user_id';
}

class AnalyticsUserProperty {
  static const String userGender = 'user_gender';
  static const String userAge = 'user_age';
}

class AnalyticsValue {
  // Auth Method Values
  static const AuthMethodValue auth = AuthMethodValue();

  // Gender Values
  static const GenderValue gender = GenderValue();

  // Tab Values
  static const TabNameValue tab = TabNameValue();

  // Photo Source Values
  static const PhotoSourceValue photo = PhotoSourceValue();

  // Share Values
  static const ShareTypeValue share = ShareTypeValue();

  // const
  static const String nullValue = 'null';
}

class AuthMethodValue {
  const AuthMethodValue();
  String get sms => 'sms';
}

class GenderValue {
  const GenderValue();
  String get male => 'male';
  String get female => 'female';
}

class TabNameValue {
  const TabNameValue();
  String get home => 'home';
  String get check => 'check';
  String get archive => 'archive';
}

class PhotoSourceValue {
  const PhotoSourceValue();
  String get camera => 'camera';
  String get gallery => 'gallery';
}

class ShareTypeValue {
  const ShareTypeValue();
  String get image => 'image';
  String get bodyResult => 'body_result';
}
