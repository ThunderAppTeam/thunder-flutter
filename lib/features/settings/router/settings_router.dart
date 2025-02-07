import 'package:go_router/go_router.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/features/settings/views/oss_licenses_page.dart';
import 'package:thunder/features/settings/views/settings_account_page.dart';
import 'package:thunder/features/settings/views/settings_info_page.dart';
import 'package:thunder/features/settings/views/settings_notification_page.dart';
import 'package:thunder/features/settings/views/settings_page.dart';

class SettingsRouter {
  static GoRoute get route => GoRoute(
        path: Routes.settings.path,
        name: Routes.settings.name,
        builder: (_, __) => const SettingsPage(),
        routes: [
          GoRoute(
            path: Routes.settings.account.path,
            name: Routes.settings.account.name,
            builder: (_, __) => const SettingsAccountPage(),
          ),
          GoRoute(
            path: Routes.settings.info.path,
            name: Routes.settings.info.name,
            builder: (_, __) => const SettingsInfoPage(),
          ),
          GoRoute(
            path: Routes.settings.notification.path,
            name: Routes.settings.notification.name,
            builder: (_, __) => const SettingsNotificationPage(),
          ),
          GoRoute(
            path: Routes.settings.ossLicenses.path,
            name: Routes.settings.ossLicenses.name,
            builder: (_, __) => const OssLicensesPage(),
          ),
        ],
      );
}
