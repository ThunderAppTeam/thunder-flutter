import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/router.dart';
import 'package:thunder/core/constants/app_const.dart';
import 'package:thunder/core/providers/token_provider.dart';
import 'package:thunder/core/services/log_service.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/theme/text/default.dart';
import 'package:thunder/firebase_options.dart';
import 'package:thunder/generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final baseUrl = dotenv.env['BASE_URL'];

  // TODO: change this logic to not use dotenv
  if (baseUrl == null || baseUrl.isEmpty) {
    LogService.fatal('Error: BASE_URL is not defined in .env file.');
    // 앱 종료
    exit(0);
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final container = ProviderContainer();
  await container.read(tokenProvider).initialize();
  runApp(
    ProviderScope(
      overrides: [
        tokenProvider.overrideWithValue(container.read(tokenProvider)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConst.appName,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ko', 'KR')],
      locale: const Locale('ko', 'KR'),
      theme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        scaffoldBackgroundColor: Colors.black,
        extensions: [
          defaultTextTheme,
        ],
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: ColorName.black,
          selectionHandleColor: ColorName.black,
        ),
      ),
      routerConfig: ref.read(routerProvider),
    );
  }
}
