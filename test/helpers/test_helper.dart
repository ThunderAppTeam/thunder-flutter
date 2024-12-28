import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thunder/core/theme/text/default.dart';
import 'package:thunder/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// 테스트용 앱 래퍼
class TestPageWrapper extends StatelessWidget {
  final Widget child;

  const TestPageWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          extensions: [
            defaultTextTheme,
          ],
        ),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: child,
      ),
    );
  }
}

/// 테스트 헬퍼 함수
Future<void> pumpPage(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(TestPageWrapper(child: child));
  await tester.pumpAndSettle();
}
