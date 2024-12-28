class TimeConsts {
  static const Duration duration1s = Duration(seconds: 1);

  static const int second = 1;
  static const int minute = 60;

  // Verification
  static const int verificationTimeLimit = 120; // 2분
  static const int verificationResendDelay = 5; // 5초 후 재전송 가능

  static const Duration navigationDuration = Duration(milliseconds: 100);
  static const Duration permissionPopupDuration = Duration(milliseconds: 500);
}
