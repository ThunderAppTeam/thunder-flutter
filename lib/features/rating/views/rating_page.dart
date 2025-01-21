import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/widgets/bottom_sheets/action_bottom_sheet.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:thunder/features/rating/view_models/rating_view_model.dart';
import 'package:thunder/features/rating/widgets/default_card.dart';
import 'package:thunder/features/rating/widgets/empty_card.dart';
import 'package:thunder/features/rating/widgets/rating_card.dart';
import 'package:thunder/features/rating/widgets/loading_card.dart';
import 'package:thunder/generated/l10n.dart';

class RatingPage extends ConsumerStatefulWidget {
  const RatingPage({super.key});

  @override
  ConsumerState<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends ConsumerState<RatingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final RatingViewModel _viewModel;

  int _selectedRating = 0;
  bool _isAnimating = false; // 애니메이션 진행 상태

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(ratingViewModelProvider.notifier);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
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

  void _onRatingChanged(int rating) {
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
    _viewModel.rate(_selectedRating);
    setState(() {
      _selectedRating = 0;
      _isAnimating = false; // 애니메이션 완료 후 입력 활성화
    });
    _animationController.reset();
  }

  void _onRefresh() {
    _viewModel.refresh();
  }

  void _onMoreTap() {
    final modalActions = [
      ModalActionItem(text: S.of(context).commonReport, onTap: _onReportTap),
      ModalActionItem(text: S.of(context).commonBlock, onTap: _onBlockTap),
    ];
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ActionBottomSheet(actions: modalActions);
      },
    );
  }

  void _onReportTap() {
    print('신고');
  }

  void _onBlockTap() {
    print('차단');
  }

  void _onError(error) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CustomBottomSheet(
        title: S.of(context).commonErrorUnknownTitle,
        subtitle: S.of(context).commonErrorUnknownSubtitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(ratingViewModelProvider, (previous, next) {
      if (next.error != null && !next.isLoading) {
        _onError(next.error);
      }
    });
    final providerState = ref.watch(ratingViewModelProvider);
    final currentIdx = ref.watch(ratingViewModelProvider.notifier).currentIdx;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Sizes.spacing16),
        child: DefaultCard(
          color: ColorName.darkBackground2,
          child: providerState.when(
            data: (bodyCheckList) {
              return Stack(
                children: [
                  if (currentIdx == bodyCheckList.length)
                    EmptyWidget(onRefresh: _onRefresh),
                  // 다음 카드 미리 대기
                  if (currentIdx < bodyCheckList.length - 1)
                    RatingWidget(
                      bodyCheckData: bodyCheckList[currentIdx + 1],
                      rating: 0,
                    ),
                  // 현재 카드 (애니메이션 적용)
                  if (currentIdx < bodyCheckList.length)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: RatingWidget(
                        bodyCheckData: bodyCheckList[currentIdx],
                        rating: _selectedRating,
                        onRatingChanged: _onRatingChanged,
                        onRatingComplete: () =>
                            _onRatingComplete(bodyCheckList.length),
                        onMoreTap: _onMoreTap,
                      ),
                    ),
                ],
              );
            },
            error: (error, stackTrace) {
              return EmptyWidget(onRefresh: _onRefresh);
            },
            loading: () {
              return LoadingWidget();
            },
          ),
        ),
      ),
    );
  }
}
