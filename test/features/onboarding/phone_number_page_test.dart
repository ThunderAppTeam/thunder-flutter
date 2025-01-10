import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thunder/features/onboarding/views/phone_number_page.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_text_field.dart';

import '../../helpers/test_helper.dart';

void main() {
  testWidgets('Phone number formatting test (010-1234-5678)',
      (WidgetTester tester) async {
    // Arrange
    await pumpPage(tester, const PhoneNumberPage());

    // Act
    final textField = find.byType(OnboardingTextField);
    await tester.enterText(textField, '01012345678');
    await tester.pump();

    // Assert
    final TextField field = tester.widget<TextField>(
      find.descendant(
        of: textField,
        matching: find.byType(TextField),
      ),
    );
    expect(field.controller?.text, '010-1234-5678');
  });
}
