import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/core/constants/time_consts.dart';

// SafeRouter Notifier
class SafeRouter {
  bool _isNavigating = false;
  bool get isNavigating => _isNavigating;

  Future<T?> pushNamed<T>(
    BuildContext context,
    String name, {
    Object? extra,
  }) async {
    if (_isNavigating) return null;
    _isNavigating = true;
    try {
      return context.pushNamed<T>(name, extra: extra);
    } finally {
      await Future.delayed(TimeConsts.navigationDuration);
      _isNavigating = false;
    }
  }

  void goNamed(
    BuildContext context,
    String name, {
    Map<String, String>? pathParameters,
    Object? extra,
  }) {
    if (_isNavigating) return;
    _isNavigating = true;
    try {
      context.goNamed(name, pathParameters: pathParameters ?? {}, extra: extra);
    } finally {
      Future.delayed(TimeConsts.navigationDuration, () {
        _isNavigating = false;
      });
    }
  }

  void goToHome(BuildContext context) {
    goNamed(context, Routes.home.name);
  }

  void goToWelcome(BuildContext context) {
    goNamed(context, Routes.welcome.name);
  }

  void pop<T>(BuildContext context, [T? result]) {
    if (_isNavigating) return;
    _isNavigating = true;
    context.pop(result);
    Future.delayed(TimeConsts.navigationDuration, () {
      _isNavigating = false;
    });
  }
}

// SafeRouter Provider
final safeRouterProvider = Provider<SafeRouter>((ref) {
  return SafeRouter();
});
