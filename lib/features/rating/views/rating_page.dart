import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/widgets/bottom_sheets/action_bottom_sheet.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:thunder/features/rating/view_models/rating_view_model.dart';
import 'package:thunder/features/rating/widgets/default_widget.dart';
import 'package:thunder/core/widgets/empty_widget.dart';
import 'package:thunder/features/rating/widgets/body_check_widget.dart';
import 'package:thunder/features/rating/widgets/loading_widget.dart';
import 'package:thunder/generated/l10n.dart';

class RatingPage extends ConsumerStatefulWidget {
  const RatingPage({super.key});

  @override
  ConsumerState<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends ConsumerState<RatingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final RatingViewModel _viewModel;

  int _selectedRating = 0;
  bool _isAnimating = false; // 애니메이션 진행 상태

  final Duration _ratingAnimationDelay = const Duration(milliseconds: 200);
  final Duration _ratingAnimationDuration = const Duration(milliseconds: 200);
  final Duration _ratingResetDelay = const Duration(milliseconds: 100);

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(ratingViewModelProvider.notifier);
    _animationController = AnimationController(
      duration: _ratingAnimationDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onRatingChanged(int rating) {
    if (_selectedRating == rating || _isAnimating) return;
    setState(() {
      _selectedRating = rating;
    });
    HapticFeedback.lightImpact();
  }

  void _onRatingComplete() async {
    final rating = _selectedRating;
    if (rating == 0) return;
    if (_viewModel.isRatingInProgress) {
      Future.delayed(_ratingResetDelay, () {
        setState(() {
          _selectedRating = 0;
        });
      });
      return;
    }
    if (_isAnimating) return;
    setState(() {
      _isAnimating = true;
    });
    await Future.delayed(_ratingAnimationDelay);
    _viewModel.rate(rating);
    await _animationController.forward();
    setState(() {
      _isAnimating = false; // 애니메이션 완료 후 입력 활성화
      _selectedRating = 0;
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
    final currentIdx = _viewModel.currentIdx;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: Sizes.spacing8),
        child: DefaultCard(
          color: ColorName.darkBackground2,
          child: providerState.when(
            data: (bodyCheckList) {
              return Stack(
                children: [
                  if (currentIdx == bodyCheckList.length)
                    EmptyWidget(
                      onButtonTap: _onRefresh,
                      guideText: S.of(context).ratingEmptyGuideText,
                      buttonText: S.of(context).commonRefresh,
                    ),
                  // 다음 카드 미리 대기
                  if (currentIdx < bodyCheckList.length - 1)
                    AnimatedOpacity(
                      opacity: _isAnimating ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: BodyCheckWidget(
                        bodyCheckData: bodyCheckList[currentIdx + 1],
                        rating: 0,
                      ),
                    ),
                  // 현재 카드 (애니메이션 적용)
                  if (currentIdx < bodyCheckList.length)
                    BodyCheckWidget(
                      bodyCheckData: bodyCheckList[currentIdx],
                      rating: _selectedRating,
                      onRatingChanged: _onRatingChanged,
                      onRatingComplete: _onRatingComplete,
                      onMoreTap: _onMoreTap,
                    ),
                ],
              );
            },
            error: (error, stackTrace) {
              return EmptyWidget(
                onButtonTap: _onRefresh,
                guideText: S.of(context).ratingEmptyGuideText,
                buttonText: S.of(context).commonRefresh,
              );
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
