import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thunder/app/router/observer.dart';
import 'package:thunder/app/screens/main_navigation_screen.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/core/constants/key_contst.dart';
import 'package:thunder/core/constants/url_const.dart';
import 'package:thunder/core/theme/constants/styles.dart';
import 'package:thunder/core/widgets/web_view_page.dart';
import 'package:thunder/features/archive/views/archive_page.dart';
import 'package:thunder/features/auth/providers/auth_state_provider.dart';
import 'package:thunder/features/photo/views/camera_page.dart';
import 'package:thunder/features/photo/views/photo_preview_page.dart';
import 'package:thunder/features/onboarding/router/onboarding_router.dart';
import 'package:thunder/features/permission/router/permission_router.dart';
import 'package:thunder/features/rating/views/rating_page.dart';
import 'package:thunder/features/body_check/views/body_check_result_page.dart';
import 'package:thunder/features/settings/router/settings_router.dart';
import 'package:thunder/features/welcome/views/welcome_page.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      debugLogDiagnostics: true,
      observers: [GoRouterObserver()],
      initialLocation: !kDebugMode ? Routes.home.path : Routes.home.path,
      redirect: (context, state) {
        final isLoggedIn = ref.read(authStateProvider).isLoggedIn;
        // 웰컴 페이지나 온보딩 페이지, 웹뷰면 리다이렉트 하지 않음
        if (state.matchedLocation == Routes.welcome.path ||
            state.matchedLocation.startsWith(Routes.onboarding.path) ||
            state.matchedLocation.startsWith(WebViewRoutes.path)) {
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
        OnboardingRouter(ref).route,
        // Main Navigation
        StatefulShellRoute.indexedStack(
          pageBuilder: (context, state, navigationShell) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              transitionDuration: Styles.pageTransitionDuration500,
              reverseTransitionDuration: Styles.pageTransitionDuration300,
              child: MainNavigationScreen(navigationShell: navigationShell),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: Routes.home.path,
                  name: Routes.home.name,
                  builder: (context, state) => const RatingPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              preload: true,
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
          path: Routes.camera.path,
          name: Routes.camera.name,
          builder: (context, state) => const CameraPage(),
        ),
        GoRoute(
          path: Routes.photoPreview.path,
          name: Routes.photoPreview.name,
          builder: (context, state) {
            final imagePath = state.extra as String;
            return PhotoPreviewPage(imagePath: imagePath);
          },
        ),
        GoRoute(
          path: Routes.bodyCheck.path,
          name: Routes.bodyCheck.name,
          pageBuilder: (context, state) {
            final bodyPhotoId =
                int.parse(state.pathParameters[KeyConst.bodyPhotoId]!);
            final extra = state.extra as Map<String, dynamic>?;
            final fromUpload = extra?[KeyConst.fromUpload] ?? false;
            final imageUrl = extra?[KeyConst.imageUrl]!;
            final pointText = extra?[KeyConst.pointText];
            return CustomTransitionPage<void>(
              key: state.pageKey,
              name: Routes.bodyCheck.name,
              transitionDuration: Styles.pageTransitionDuration400,
              reverseTransitionDuration: Styles.pageTransitionDuration300,
              child: BodyCheckResultPage(
                bodyPhotoId: bodyPhotoId,
                fromUpload: fromUpload,
                imageUrl: imageUrl,
                pointText: pointText,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          },
        ),
        SettingsRouter.route,
        PermissionRouter.route,
        GoRoute(
          path: Routes.webview.terms.path,
          name: Routes.webview.terms.name,
          builder: (_, __) => const WebViewPage(url: UrlConst.termsOfService),
        ),
        GoRoute(
          path: Routes.webview.privacy.path,
          name: Routes.webview.privacy.name,
          builder: (_, __) => const WebViewPage(url: UrlConst.privacyPolicy),
        ),
      ],
    );
  },
);
