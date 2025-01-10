import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thunder/app/screens/main_navigation_screen.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/features/archive/views/archive_page.dart';
import 'package:thunder/features/auth/repositories/auth_repository.dart';
import 'package:thunder/features/camera/views/camera_page.dart';
import 'package:thunder/features/feed/views/feed_page.dart';
import 'package:thunder/features/noonbody/views/noonbody_waiting_page.dart';
import 'package:thunder/features/onboarding/views/phone_number_page.dart';
import 'package:thunder/features/welcome/views/welcome_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    debugLogDiagnostics: true,
    // initialLocation: Routes.home.path,
    initialLocation: !kDebugMode ? Routes.home.path : Routes.home.path,
    redirect: (context, state) {
      final isLoggedIn = !ref.watch(authRepoProvider).isLoggedIn;

      // 웰컴 페이지나 온보딩 페이지면 리다이렉트 하지 않음
      if (state.matchedLocation == Routes.welcome.path ||
          state.matchedLocation.startsWith(Routes.onboarding.path)) {
        return null;
      }

      // 비로그인 상태에서는 웰컴 페이지로
      if (!isLoggedIn) {
        return Routes.welcome.path;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: Routes.welcome.path,
        name: Routes.welcome.name,
        builder: (_, __) => const WelcomePage(),
      ),
      GoRoute(
        path: Routes.onboarding.path,
        name: Routes.onboarding.name,
        builder: (_, __) => const PhoneNumberPage(),
      ),
      // Main Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainNavigationScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home.path,
                name: Routes.home.name,
                builder: (context, state) => const FeedPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.archive.path,
                name: Routes.archive.name,
                builder: (context, state) => const ArchivePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routes.measure.path,
        name: Routes.measure.name,
        builder: (context, state) => const CameraPage(),
      ),
      GoRoute(
        path: Routes.noonbody.path,
        name: Routes.noonbody.name,
        builder: (context, state) => NoonbodyWaitingPage(
          imagePath: state.extra as String,
        ),
      ),
    ],
  );
});
