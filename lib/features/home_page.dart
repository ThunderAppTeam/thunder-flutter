import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thunder/core/router/routes.dart';
import 'package:thunder/features/auth/repositories/auth_repository.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Home Page (로그인 완료)'),
            TextButton(
              onPressed: () async {
                await ref.read(authRepoProvider).deleteUser();
                if (context.mounted) {
                  context.go(Routes.welcome.path);
                }
              },
              child: const Text('탈퇴'),
            ),
          ],
        ),
      ),
    );
  }
}
