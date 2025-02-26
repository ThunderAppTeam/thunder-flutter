class TimeConst {
  static const int second = 1;
  static const int minute = 60;

  // Verification
  static const int verificationTimeLimit = 180; // 3분
  static const int verificationCoolDown = 10; // 10초 후 재전송 가능

  /// 백엔드에 과한 요청을 막기 위해, 버튼 클릭 후 2초 동안 버튼 비활성화
  static const Duration onboardingButtonCoolDown = Duration(milliseconds: 2000);
  static const Duration safeRouterDuration = Duration(milliseconds: 500);
  static const Duration permissionPopupDuration = Duration(milliseconds: 500);

  // camera
  static const Duration cameraFlashDuration = Duration(milliseconds: 100);

  // welcome
  static const int welcomeImageTransitionInterval = 3;
  static const Duration welcomeImageTransitionDuration =
      Duration(milliseconds: 800);
}
