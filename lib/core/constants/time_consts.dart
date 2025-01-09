class TimeConsts {
  static const int second = 1;
  static const int minute = 60;

  // Verification
  static const int verificationTimeLimit = 180; // 3분
  static const int verificationCoolDown = 5; // 5초 후 재전송 가능

  static const Duration navigationDuration = Duration(milliseconds: 500);
  static const Duration permissionPopupDuration = Duration(milliseconds: 500);

  // camera
  static const Duration cameraFlashDuration = Duration(milliseconds: 100);

  // welcome
  static const int welcomeImageTransitionInterval = 3;
  static const Duration welcomeImageTransitionDuration =
      Duration(milliseconds: 800);
}
