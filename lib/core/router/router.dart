import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:thunder/core/router/routes.dart';
import 'package:thunder/features/home_page.dart';
import 'package:thunder/features/onboarding/views/welcome_page.dart';
import 'package:thunder/features/onboarding/views/birthdate_page.dart';
import 'package:thunder/features/onboarding/views/gender_page.dart';
import 'package:thunder/features/onboarding/views/nickname_page.dart';
import 'package:thunder/features/onboarding/views/phone_number_page.dart';
import 'package:thunder/features/onboarding/views/verification_page.dart';

final router = GoRouter(
  // initialLocation: Routes.start.path,
  // TODO: 이후에 배포 후에 주석 해제
  initialLocation: !kDebugMode ? Routes.start.path : Routes.start.path,
  routes: [
    // Onboarding
    GoRoute(
      path: Routes.start.path,
      name: Routes.start.name,
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: Routes.phoneNumber.path,
      name: Routes.phoneNumber.name,
      builder: (context, state) => const PhoneNumberPage(),
    ),
    GoRoute(
      path: Routes.verification.path,
      name: Routes.verification.name,
      builder: (context, state) => const VerificationPage(),
    ),
    GoRoute(
      path: Routes.nickname.path,
      name: Routes.nickname.name,
      builder: (context, state) => const NicknamePage(),
    ),
    GoRoute(
      path: Routes.birthdate.path,
      name: Routes.birthdate.name,
      builder: (context, state) => const BirthdatePage(),
    ),
    GoRoute(
      path: Routes.gender.path,
      name: Routes.gender.name,
      builder: (context, state) => const GenderPage(),
    ),

    GoRoute(
      path: Routes.home.path,
      name: Routes.home.name,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
