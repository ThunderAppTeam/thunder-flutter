import 'package:flutter/widgets.dart';
import 'package:thunder/core/services/analytics_service.dart';

class GoRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) {
      AnalyticsService.screenView(screenName: route.settings.name!);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null && previousRoute.settings.name != null) {
      AnalyticsService.screenView(screenName: previousRoute.settings.name!);
    }
  }
}
