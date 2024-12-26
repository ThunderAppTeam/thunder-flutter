import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  final PageController _pageController = PageController();
  int _counter = 0; // 테스트용 카운터

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemBuilder: (context, index) {
          if (index == 0) {
            // 첫 번째 페이지에 카운터 표시
            return Center(
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
                ],
              ),
            );
          }

          // 나머지 페이지는 기존대로
          return Container(
            color: Colors.red,
            child: const Text('로그아웃'),
          );
        },
        onPageChanged: (index) {
          // 필요한 경우 다음 페이지 프리로드
          // ref.read(feedProvider.notifier).loadMorePosts();
        },
      ),
    );
  }
}
