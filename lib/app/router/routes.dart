final class Routes {
  static const welcome = (
    name: 'welcome',
    path: '/welcome',
  );

  // 온보딩 페이지
  static const onboarding = (
    name: 'onboarding',
    path: '/onboarding',
  );

  // 메인 네비게이션
  static const home = (
    name: 'home',
    path: '/',
  );

  static const measure = (
    name: 'measure',
    path: '/measure',
  );

  static const archive = (
    name: 'archive',
    path: '/archive',
  );

  static const bodyCheck = (
    name: 'bodyCheck',
    path: '/bodyCheck/:bodyPhotoId',
  );

  static const settings = (
    name: 'settings',
    path: '/settings',
  );

  static const permissionNotification = (
    name: 'permissionNotification',
    path: '/permission/notification',
  );

  static const permissionTracking = (
    name: 'permissionTracking',
    path: '/permission/tracking',
  );
}
