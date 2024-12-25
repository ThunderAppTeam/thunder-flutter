import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thunder/core/router/routes.dart';
import 'package:thunder/core/router/safe_router.dart';
import 'package:thunder/core/widgets/web_view_page.dart';
import 'package:thunder/features/auth/repositories/auth_repository.dart';
import 'package:thunder/features/home_page.dart';
import 'package:thunder/features/onboarding/views/welcome_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.onboarding.path,
    observers: [SafeNavigatorObserver()],
    redirect: (context, state) {
      final isLoggedIn = ref.watch(authRepoProvider).isLoggedIn;
      if (!isLoggedIn) {
        // 비로그인 상태에서 온보딩이 아닌 페이지 접근 시 온보딩으로
        if (state.matchedLocation != Routes.onboarding.path) {
          return Routes.onboarding.path;
        }
      }
      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) => child,
        routes: [
          GoRoute(
            path: Routes.onboarding.path,
            name: Routes.onboarding.name,
            builder: (_, __) => const WelcomePage(),
          ),
          GoRoute(
            path: Routes.home.path,
            name: Routes.home.name,
            builder: (_, __) => const HomePage(),
          ),
          GoRoute(
            path: Routes.webView.path,
            name: Routes.webView.name,
            builder: (_, state) => WebViewPage(
              url: state.extra as String,
            ),
          ),
        ],
      ),
    ],
  );
});
