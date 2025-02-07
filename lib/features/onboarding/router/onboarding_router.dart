import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/features/onboarding/providers/onboarding_provider.dart';
import 'package:thunder/features/onboarding/views/birthdate_page.dart';
import 'package:thunder/features/onboarding/views/gender_page.dart';
import 'package:thunder/features/onboarding/views/nickname_page.dart';
import 'package:thunder/features/onboarding/views/phone_number_page.dart';
import 'package:thunder/features/onboarding/views/verification_page.dart';

class OnboardingRouter {
  final Ref _ref;
  OnboardingRouter(this._ref);

  GoRoute get route => GoRoute(
        path: Routes.onboarding.path,
        name: Routes.onboarding.name,
        redirect: (_, state) {
          if (state.fullPath == Routes.onboarding.path) {
            return Routes.onboarding.phoneNumber.fullPath;
          }
          final onboardingNotifier = _ref.read(onboardingProvider.notifier);
          if (!onboardingNotifier.isDataValid()) {
            onboardingNotifier.redirectToPhoneNumber();
            return Routes.welcome.path;
          }
          return null;
        },
        routes: [
          GoRoute(
            path: Routes.onboarding.phoneNumber.path,
            name: Routes.onboarding.phoneNumber.name,
            builder: (_, __) => const PhoneNumberPage(),
          ),
          GoRoute(
            path: Routes.onboarding.verification.path,
            name: Routes.onboarding.verification.name,
            builder: (_, __) => const VerificationPage(),
          ),
          GoRoute(
            path: Routes.onboarding.nickname.path,
            name: Routes.onboarding.nickname.name,
            builder: (_, __) => const NicknamePage(),
          ),
          GoRoute(
            path: Routes.onboarding.birthdate.path,
            name: Routes.onboarding.birthdate.name,
            builder: (_, __) => const BirthdatePage(),
          ),
          GoRoute(
            path: Routes.onboarding.gender.path,
            name: Routes.onboarding.gender.name,
            builder: (_, __) => const GenderPage(),
          ),
        ],
      );
}
