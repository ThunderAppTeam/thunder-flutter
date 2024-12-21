import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:thunder/core/theme/constants/styles.dart';

class SafeNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) async {
    super.didPush(route, previousRoute);
    // 0.1초 정도 navigation이 완료되기 전에 다시 네비게이션을 시도하는 것을 방지
    await Future.delayed(Styles.duration100);
    SafeRouter._isNavigating = false;
  }
}

class SafeRouter {
  static bool _isNavigating = false;

  static bool get isNavigating => _isNavigating;

  static Future<T?> push<T>(BuildContext context, String location) async {
    if (_isNavigating) return null;
    _isNavigating = true;
    return context.push<T>(location);
  }

  static Future<T?> pushNamed<T>(BuildContext context, String name,
      {Object? extra}) async {
    if (_isNavigating) return null;
    _isNavigating = true;
    return context.pushNamed<T>(name, extra: extra);
  }
}
