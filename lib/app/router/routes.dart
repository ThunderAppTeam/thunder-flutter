class Route {
  final String path;
  final String name;
  final String? fullPath;

  const Route({
    required this.path,
    required this.name,
    this.fullPath,
  });
}

final class Routes {
  static const welcome = Route(path: '/welcome', name: 'welcome');

  static final onboarding = OnboardingRoutes();
  static final permission = PermissionRoutes();
  static final settings = SettingsRoutes();
  static final webview = WebViewRoutes();

  static const home = Route(path: '/', name: 'home');
  static const camera = Route(path: '/camera', name: 'camera');
  static const photoPreview =
      Route(path: '/photo-preview', name: 'photoPreview');
  static const archive = Route(path: '/archive', name: 'archive');
  static const bodyCheck =
      Route(path: '/bodyCheck/:bodyPhotoId', name: 'bodyCheck');
}

class OnboardingRoutes {
  final String path = '/onboarding';
  final String name = 'onboarding';

  final phoneNumber = const Route(
    path: 'phone',
    name: 'onboardingPhone',
    fullPath: '/onboarding/phone',
  );
  final verification =
      const Route(path: 'verification', name: 'onboardingVerification');
  final nickname = const Route(path: 'nickname', name: 'onboardingNickname');
  final birthdate = const Route(path: 'birthdate', name: 'onboardingBirthdate');
  final gender = const Route(path: 'gender', name: 'onboardingGender');

  const OnboardingRoutes();
}

class SettingsRoutes {
  final String path = '/settings';
  final String name = 'settings';

  final account = const Route(path: 'account', name: 'settingsAccount');
  final info = const Route(path: 'info', name: 'settingsInfo');
  final notification =
      const Route(path: 'notification', name: 'settingsNotification');
  final ossLicenses =
      const Route(path: 'oss-licenses', name: 'settingsOssLicenses');
  const SettingsRoutes();
}

class PermissionRoutes {
  final String path = '/permission';
  final String name = 'permission';

  final notification =
      const Route(path: 'notification', name: 'permissionNotification');
  final tracking = const Route(path: 'tracking', name: 'permissionTracking');

  const PermissionRoutes();
}

class WebViewRoutes {
  static const path = '/webview';
  static const name = 'webview';
  final terms = const Route(path: '$path/terms', name: '${name}Terms');
  final privacy = const Route(path: '$path/privacy', name: '${name}Privacy');

  const WebViewRoutes();
}
