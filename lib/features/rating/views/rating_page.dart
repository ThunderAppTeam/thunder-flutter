import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/show_utils.dart';
import 'package:thunder/core/widgets/bottom_sheets/action_bottom_sheet.dart';
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
    final reportOptions = [
      S.of(context).reportOptionSexualContent,
      S.of(context).reportOptionNonRelatedContent,
      S.of(context).reportOptionFakeProfile,
      S.of(context).reportOptionBadWords,
      S.of(context).reportOptionChildSexualContent,
      S.of(context).surveyOtherOption,
    ];

    final result = await showSurveyBottomSheet(
      context,
      title: S.of(context).commonReport,
      options: reportOptions,
      buttonText: S.of(context).commonConfirm,
      onButtonTap: () {},
      hasOtherOption: true,
    );
    if (result == null) return;
    _viewModel.skip();
  }

  void _onBlockTap() async {
    final confirmed = await showAlertDialog(
      context,
      title: S.of(context).ratingBlockTitle,
      subtitle: S.of(context).ratingBlockSubtitle,
      confirmText: S.of(context).commonBlock,
    );
    if (confirmed == true && context.mounted) {
      _viewModel.block();
    }
  }

  void _onError(error) {
    showCommonUnknownErrorBottomSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(ratingViewModelProvider, (previous, next) {
      if (next.error != null && !next.isLoading) {
        _onError(next.error);
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
              return LoadingWidget();
            },
          ),
        ),
      ),
    );
  }
}
