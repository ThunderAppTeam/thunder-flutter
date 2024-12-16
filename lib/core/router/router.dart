import 'package:go_router/go_router.dart';
import 'package:noon_body/core/router/routes.dart';
import 'package:noon_body/features/onboarding/views/welcome_page.dart';
import 'package:noon_body/features/onboarding/views/birthdate_page.dart';
import 'package:noon_body/features/onboarding/views/gender_page.dart';
import 'package:noon_body/features/onboarding/views/nickname_page.dart';
import 'package:noon_body/features/onboarding/views/phone_number_page.dart';
import 'package:noon_body/features/onboarding/views/verification_page.dart';

final router = GoRouter(
  initialLocation: Routes.start.path,
  routes: [
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
  ],
);
