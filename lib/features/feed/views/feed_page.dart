import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/features/auth/repositories/auth_repository.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  int _counter = 0; // 테스트용 카운터

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '카운터: $_counter',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _counter++;
                });
              },
              child: const Text('증가'),
            ),
            ElevatedButton(
              onPressed: () async {
                await ref.read(authRepoProvider).signOut();
                if (context.mounted) {
                  ref
                      .read(safeRouterProvider)
                      .pushNamed(context, Routes.welcome.name);
                }
              },
              child: const Text('로그 아웃'),
            ),
          ],
        ),
      ),
    );
  }
}
