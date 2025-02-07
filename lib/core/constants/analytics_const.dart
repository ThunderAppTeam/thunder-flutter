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
  static const AuthMethod auth = AuthMethod();

  // Tab Values
  static const TabName tab = TabName();

  // Photo Source Values
  static const PhotoSource photo = PhotoSource();

  // Share Values
  static const ShareType share = ShareType();

  // const
  static const String nullValue = 'null';
}

class AuthMethod {
  const AuthMethod();
  String get sms => 'sms';
}

class TabName {
  const TabName();
  String get home => 'home';
  String get check => 'check';
  String get archive => 'archive';
}

class PhotoSource {
  const PhotoSource();
  String get camera => 'camera';
  String get gallery => 'gallery';
}

class ShareType {
  const ShareType();
  String get image => 'image';
  String get bodyResult => 'body_result';
}
