import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/show_utils.dart';
import 'package:thunder/core/widgets/bottom_sheets/action_bottom_sheet.dart';
import 'package:thunder/features/rating/models/data/flag_reason_data.dart';
import 'package:thunder/features/rating/view_models/flag_view_model.dart';
import 'package:thunder/features/rating/view_models/rating_view_model.dart';
import 'package:thunder/features/rating/widgets/default_widget.dart';
import 'package:thunder/core/widgets/empty_widget.dart';
import 'package:thunder/features/rating/widgets/body_check_widget.dart';
import 'package:thunder/features/rating/widgets/loading_widget.dart';
import 'package:thunder/features/rating/widgets/skeleton_body_check_widget.dart';
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
  late final FlagViewModel _flagViewModel;

  late final List<FlagReasonData> _flagDataList;

  int _selectedRating = 0;
  bool _isAnimating = false; // 애니메이션 진행 상태
  bool _isShowingError = false; // 에러 메시지 표시 상태 추적

  final Duration _ratingAnimationDelay = const Duration(milliseconds: 200);
  final Duration _ratingAnimationDuration = const Duration(milliseconds: 200);
  final Duration _ratingResetDelay = const Duration(milliseconds: 100);

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(ratingViewModelProvider.notifier);
    _flagViewModel = ref.read(flagViewModelProvider.notifier);
    _animationController = AnimationController(
      duration: _ratingAnimationDuration,
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _flagDataList = await _flagViewModel.fetchFlagList();
    });
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
    _viewModel.rate(rating);
    await Future.delayed(_ratingAnimationDelay);
    await _animationController.forward();
    setState(() {
      _isAnimating = false; // 애니메이션 완료 후 입력 활성화
      _selectedRating = 0;
    });
    _animationController.reset();
    _viewModel.completeRating();
  }

  void _onRefresh() {
    _viewModel.refresh();
  }

  void _onMoreTap() {
    final modalActions = [
      ModalActionItem(text: S.of(context).commonReport, onTap: _onReportTap),
      ModalActionItem(text: S.of(context).commonBlock, onTap: _onBlockTap),
    ];
    showActionBottomSheet(context, modalActions);
  }

  Future<void> _onReportTap() async {
    if (_flagDataList.isEmpty) _onError();
    if (mounted) {
      final result = await showSurveyBottomSheet(
        context,
        title: S.of(context).commonReport,
        options: _flagDataList.map((e) => e.description).toList(),
        buttonText: S.of(context).commonConfirm,
        hasOtherOption: true,
      );
      if (result == null) return;
      final flagData = _flagDataList[result.index];
      await _flagViewModel.flag(
        _viewModel.viewedBodyPhotoId,
        flagData.flagReason,
        result.isOtherOption ? result.otherOptionText : null,
      );
      await Future.delayed(_ratingAnimationDelay);
      _viewModel.skip();
    }
  }

  void _onBlockTap() async {
    final confirmed = await showAlertDialog(
      context,
      title: S.of(context).ratingBlockTitle,
      subtitle: S.of(context).ratingBlockSubtitle,
      confirmText: S.of(context).commonBlock,
    );
    if (confirmed == true && context.mounted) {
      await _flagViewModel.block(_viewModel.viewedMemberId);
      await Future.delayed(_ratingAnimationDelay);
      _viewModel.skip();
    }
  }

  void _onError() {
    if (_isShowingError) return;
    _isShowingError = true;
    if (!mounted) return;
    showCommonUnknownErrorBottomSheet(context).then((_) {
      _isShowingError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(ratingViewModelProvider, (previous, next) {
      if (next.error != null &&
          previous?.error != next.error &&
          !next.isLoading) {
        _onError();
      }
    });
    ref.listen(flagViewModelProvider, (previous, next) {
      if (next.error != null &&
          previous?.error != next.error &&
          !next.isLoading) {
        _onError();
      }
    });

    final providerState = ref.watch(ratingViewModelProvider);

    final viewedIdx = _viewModel.viewedIdx;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: Sizes.spacing8),
        child: DefaultCard(
          color: ColorName.darkBackground2,
          child: providerState.when(
            data: (bodyCheckList) {
              return Stack(
                children: [
                  if (viewedIdx >= bodyCheckList.length)
                    EmptyWidget(
                      onButtonTap: _onRefresh,
                      guideText: S.of(context).ratingEmptyGuideText,
                      buttonText: S.of(context).commonRefresh,
                    ),
                  // 다음 카드 미리 대기
                  if (viewedIdx < bodyCheckList.length - 1)
                    AnimatedOpacity(
                      opacity: _isAnimating ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: BodyCheckWidget(
                        bodyCheckData: bodyCheckList[viewedIdx + 1],
                        rating: 0,
                      ),
                    ),
                  // 현재 카드 (애니메이션 적용)
                  if (viewedIdx < bodyCheckList.length)
                    BodyCheckWidget(
                      bodyCheckData: bodyCheckList[viewedIdx],
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
              if (_viewModel.searching) {
                return LoadingWidget();
              } else {
                return SkeletonBodyCheckWidget();
              }
            },
          ),
        ),
      ),
    );
  }
}
