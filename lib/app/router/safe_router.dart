import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/core/constants/key_contst.dart';
import 'package:thunder/core/constants/time_const.dart';

final safeRouterStateProvider = StateProvider<bool>((ref) {
  return false;
});

// SafeRouter Notifier
class SafeRouter {
  final StateController<bool> _navigating;
  bool get isNavigating => _navigating.state;
  Timer? _navigationTimer;
  SafeRouter(this._navigating);

  void _resetNavigating(BuildContext context) {
    _navigationTimer?.cancel();
    _navigationTimer = Timer(TimeConst.safeRouterDuration, () {
      _navigating.state = false;
    });
  }

  Future<T?> pushNamed<T>(
    BuildContext context,
    String name, {
    Map<String, String>? pathParameters,
    Object? extra,
  }) async {
    if (isNavigating) return null;
    _navigating.state = true;
    try {
      return context.pushNamed<T>(name,
          pathParameters: pathParameters ?? {}, extra: extra);
    } finally {
      _resetNavigating(context);
    }
  }

  void goNamed(
    BuildContext context,
    String name, {
    Map<String, String>? pathParameters,
    Object? extra,
  }) {
    if (isNavigating) return;
    _navigating.state = true;
    try {
      context.goNamed(name, pathParameters: pathParameters ?? {}, extra: extra);
    } finally {
      _resetNavigating(context);
    }
  }

  void goToHome(BuildContext context, {bool skip = false}) {
    if (skip) {
      context.goNamed(Routes.home.name);
    } else {
      goNamed(context, Routes.home.name);
    }
  }

  void goToWelcome(BuildContext context, {bool skip = false}) {
    if (skip) {
      context.goNamed(Routes.welcome.name);
    } else {
      goNamed(context, Routes.welcome.name);
    }
  }

  void goToArchive(BuildContext context, {bool skip = false}) {
    if (skip) {
      context
          .goNamed(Routes.archive.name, extra: {KeyConst.skipAnalytics: true});
    } else {
      goNamed(context, Routes.archive.name);
    }
  }

  void replaceNamed(
    BuildContext context,
    String name, {
    Map<String, String>? pathParameters,
    Object? extra,
  }) {
    if (isNavigating) return;
    _navigating.state = true;
    try {
      context.replaceNamed(
        name,
        pathParameters: pathParameters ?? {},
        extra: extra,
      );
    } finally {
      _resetNavigating(context);
    }
  }

  void pop<T>(BuildContext context, [T? result]) {
    if (isNavigating) return;
    _navigating.state = true;
    try {
      context.pop(result);
    } finally {
      _resetNavigating(context);
    }
  }

  void dispose() {
    _navigationTimer?.cancel();
  }
}

final safeRouterProvider = Provider<SafeRouter>((ref) {
  final isNavigating = ref.read(safeRouterStateProvider.notifier);
  final router = SafeRouter(isNavigating);

  ref.onDispose(() {
    router.dispose();
  });

  return router;
});
