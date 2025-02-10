import 'package:go_router/go_router.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/features/permission/views/notification_permission_page.dart';
import 'package:thunder/features/permission/views/traking_permission_page.dart';

class PermissionRouter {
  static GoRoute get route => GoRoute(
        path: Routes.permission.path,
        name: Routes.permission.name,
        redirect: (_, state) {
          if (state.fullPath == Routes.permission.path) {
            return '${Routes.permission.path}/${Routes.permission.notification.path}';
          }
          return null;
        },
        routes: [
          GoRoute(
            path: Routes.permission.notification.path,
            name: Routes.permission.notification.name,
            builder: (context, state) => const NotificationPermissionPage(),
          ),
          GoRoute(
            path: Routes.permission.tracking.path,
            name: Routes.permission.tracking.name,
            builder: (context, state) => const TrackingPermissionPage(),
          ),
        ],
      );
}
