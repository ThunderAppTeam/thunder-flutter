import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
              onPressed: () {
                ref.read(authRepoProvider).signOut();
              },
              child: const Text('로그아웃'),
            ),
          ],
        ),
      ),
    );
  }
}
