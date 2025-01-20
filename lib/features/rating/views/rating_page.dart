import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/features/rating/view_models/rating_view_model.dart';
import 'package:thunder/features/rating/widgets/empty_card.dart';

import 'package:thunder/features/rating/widgets/rating_card.dart';
import 'package:thunder/features/rating/widgets/loading_card.dart';

class RatingPage extends ConsumerStatefulWidget {
  const RatingPage({super.key});

  @override
  ConsumerState<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends ConsumerState<RatingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  int _selectedRating = 0;
  int _currentIndex = 0;
  bool _isAnimating = false; // 애니메이션 진행 상태

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onRate(int rating) {
    if (_isAnimating) return; // 애니메이션 중이면 무시
    if (rating != _selectedRating) {
      setState(() {
        _selectedRating = rating;
      });
    }
  }

  void _onRatingComplete(int listLength) async {
    if (_isAnimating) return; // 애니메이션 중이면 중복 호출 방지

    setState(() {
      _isAnimating = true;
    });

    await _animationController.forward();

    setState(() {
      _currentIndex++;
      _selectedRating = 0;
      _isAnimating = false; // 애니메이션 완료 후 입력 활성화
    });

    _animationController.reset();
  }

  void _onRefresh() {
    setState(() {
      _currentIndex = 0;
    });
    ref.read(bodyCheckListProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final providerState = ref.watch(bodyCheckListProvider);
    return providerState.when(
      data: (bodyCheckList) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.all(Sizes.spacing16),
            child: Stack(
              children: [
                // 모든 카드를 평가했을 때
                EmptyCard(onRefresh: _onRefresh),
                // 다음 카드 미리 대기
                if (_currentIndex < bodyCheckList.length - 1)
                  RadingCard(
                    bodyCheckData: bodyCheckList[_currentIndex + 1],
                    rating: 0,
                  ),

                // 현재 카드 (애니메이션 적용)
                if (_currentIndex < bodyCheckList.length)
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: RadingCard(
                      bodyCheckData: bodyCheckList[_currentIndex],
                      rating: _selectedRating,
                      onRatingChanged: _onRate,
                      onRatingComplete: () =>
                          _onRatingComplete(bodyCheckList.length),
                      onFlagTap: () {
                        print('flag');
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Scaffold(
          body: Center(child: Text('Error: $error')),
        );
      },
      loading: () {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.all(Sizes.spacing16),
            child: LoadingCard(),
          ),
        );
      },
    );
  }
}
