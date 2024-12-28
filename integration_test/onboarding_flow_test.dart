import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:thunder/features/onboarding/views/widgets/bottom_sheets/terms_bottom_sheet.dart';
import 'package:thunder/features/onboarding/views/widgets/gender_button.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_button.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_text_field.dart';
import 'package:thunder/firebase_options.dart';
import 'package:thunder/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAuth.instance.signOut();
  });

  group('Onboarding Flow Test', () {
    testWidgets('Complete onboarding process', (tester) async {
      await tester.pumpWidget(
        ProviderScope(child: const MyApp()),
      );
      await tester.pumpAndSettle();

      // 시작하기 화면
      await tester.pumpAndSettle(const Duration(seconds: 1));
      final startButton = find.byType(OnboardingButton);
      expect(startButton, findsOneWidget);
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      await tester.pumpAndSettle(const Duration(seconds: 1));

      // 전화번호 입력
      final phoneField = find.byType(OnboardingTextField);
      expect(phoneField, findsOneWidget);
      await tester.enterText(phoneField, '01012345678');
      await tester.pumpAndSettle(); // 버튼 애니메이션 끝나기 기다리기
      final phoneNextButton = find.byType(OnboardingButton);
      await tester.tap(phoneNextButton);
      await tester.pumpAndSettle();

      await tester.pumpAndSettle(const Duration(seconds: 1));

      // 인증번호 입력
      final verificationField = find.byType(OnboardingTextField);
      expect(verificationField, findsOneWidget);
      await tester.enterText(verificationField, '111111');
      await tester.pumpAndSettle();
      final verificationButton = find.byType(OnboardingButton);
      await tester.tap(verificationButton);
      await tester.pumpAndSettle();

      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // 닉네임 입력
      final nicknameField = find.byType(OnboardingTextField);
      expect(nicknameField, findsOneWidget);
      await tester.enterText(nicknameField, '테스트계정');

      await tester.pumpAndSettle();
      final nicknameNextButton = find.byType(OnboardingButton);
      await tester.tap(nicknameNextButton);
      await tester.pumpAndSettle();

      await tester.pumpAndSettle(const Duration(seconds: 1));

      // // 생년월일 입력
      final birthFields = find.byType(OnboardingTextField);
      expect(birthFields, findsNWidgets(3)); // 년, 월, 일 필드

      await tester.enterText(birthFields.at(0), '1990');
      await tester.enterText(birthFields.at(1), '01');
      await tester.enterText(birthFields.at(2), '01');
      await tester.pumpAndSettle();

      final birthNextButton = find.byType(OnboardingButton);
      await tester.tap(birthNextButton);
      await tester.pumpAndSettle();

      await tester.pumpAndSettle(const Duration(seconds: 1));

      // 성별 선택
      final genderButtons = find.byType(GenderButton);
      expect(genderButtons, findsNWidgets(2)); // 남성, 여성 버튼

      await tester.tap(genderButtons.first); // 첫 번째 버튼(여성) 선택
      await tester.pumpAndSettle();

      final genderNextButton = find.byType(OnboardingButton);
      await tester.tap(genderNextButton);
      await tester.pumpAndSettle();

      await tester.pumpAndSettle(const Duration(seconds: 1));

      // 약관 동의 화면
      final termsBottomSheet = find.byType(TermsBottomSheet);

      // 모두 동의 체크
      final allAgreeCheckbox = find.descendant(
        of: termsBottomSheet,
        matching: find.byType(Checkbox),
      );
      expect(allAgreeCheckbox, findsOneWidget);
      await tester.tap(allAgreeCheckbox);
      await tester.pumpAndSettle();

      final allAgreeNextButton = find.descendant(
        of: termsBottomSheet,
        matching: find.byType(OnboardingButton),
      );
      await tester.tap(allAgreeNextButton);
      await tester.pumpAndSettle();

      await tester.pumpAndSettle(const Duration(seconds: 1));

      // 온보딩 완료 확인 (메인 화면)

      expect(find.byType(BottomNavigationBar), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 완료
    });
  });
}
