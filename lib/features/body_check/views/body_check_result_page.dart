import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/enums/gender.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/constants/styles.dart';
import 'package:thunder/core/theme/gen/assets.gen.dart';
import 'package:thunder/core/theme/icon/thunder_icons_icons.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:thunder/core/widgets/buttons/custom_wide_button.dart';
import 'package:thunder/core/widgets/custom_circular_indicator.dart';
import 'package:thunder/core/widgets/thunder_network_image.dart';
import 'package:thunder/features/body_check/view_models/body_check_result_view_model.dart';
import 'package:thunder/generated/l10n.dart';

class BodyCheckResultPage extends ConsumerStatefulWidget {
  final int bodyPhotoId;
  final bool fromUpload;
  final String imageUrl;
  final String? pointText;

  const BodyCheckResultPage({
    super.key,
    required this.bodyPhotoId,
    this.fromUpload = false,
    required this.imageUrl,
    this.pointText,
  });

  @override
  ConsumerState<BodyCheckResultPage> createState() =>
      _BodyCheckResultPageState();
}

class _BodyCheckResultPageState extends ConsumerState<BodyCheckResultPage> {
  bool _isAnimationStarted = false;
  final Duration _animationDuration = const Duration(milliseconds: 700);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
          // 페이지 완전 전환 보단 약간 빠르게 시작
          Styles.pageTransitionDuration500 - Duration(milliseconds: 200), () {
        setState(() {
          _isAnimationStarted = true;
        });
      });
    });
  }

  void _onError(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CustomBottomSheet(
        title: S.of(context).commonErrorUnknownTitle,
        subtitle: S.of(context).commonErrorUnknownSubtitle,
      ),
    );
  }

  void _onShare() {
    // TODO: 공유하기 기능 구현
  }

  Widget _buildAnimatedOpacity({
    required bool hasValue,
    required Widget child,
  }) {
    return AnimatedOpacity(
      opacity: _isAnimationStarted && hasValue ? 1.0 : 0.0,
      duration: _animationDuration,
      curve: Curves.easeInOut,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final resultState = ref.watch(bodyCheckResultProvider(widget.bodyPhotoId));
    final textTheme = getTextTheme(context);
    ref.listen(bodyCheckResultProvider(widget.bodyPhotoId), (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        _onError(context);
      }
    });

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).bodyCheckWaitingTitle,
          actions: [
            CustomAppBarAction(
              type: CustomAppBarActionType.icon,
              icon: ThunderIcons.moreHoriz,
              onTap: () {},
            ),
            if (widget.fromUpload)
              CustomAppBarAction(
                type: CustomAppBarActionType.icon,
                icon: ThunderIcons.closeSquareLight,
                onTap: () {
                  ref
                      .read(safeRouterProvider)
                      .goNamed(context, Routes.archive.name);
                },
              ),
          ],
          showBackButton: !widget.fromUpload,
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            top: Sizes.spacing16,
            left: Sizes.spacing16,
            right: Sizes.spacing16,
            bottom: Sizes.spacing8,
          ),
          child: Column(
            children: [
              Expanded(
                  child: Stack(
                children: [
                  Hero(
                    tag: 'body_check_image_${widget.bodyPhotoId}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Sizes.radius16),
                      child: ThunderNetworkImage(
                        imageUrl: resultState.maybeWhen(
                          data: (result) => result.imageUrl,
                          orElse: () => widget.imageUrl,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: AnimatedContainer(
                      duration: _animationDuration,
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(Sizes.spacing16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.0),
                            Colors.black.withOpacity(
                                _isAnimationStarted && resultState.hasValue
                                    ? 0.25
                                    : 0.0),
                            Colors.black.withOpacity(
                                _isAnimationStarted && resultState.hasValue
                                    ? 0.5
                                    : 0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Hero(
                                tag: 'body_check_score_${widget.bodyPhotoId}',
                                child: Material(
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      Assets.images.logos.thunderSymbolW.svg(),
                                      Gaps.h8,
                                      if (widget.pointText != null)
                                        Text(
                                          widget.pointText!,
                                          style: textTheme.textHead32,
                                        )
                                      else
                                        Text(
                                          resultState.maybeWhen(
                                            data: (result) =>
                                                result.reviewCount == 0
                                                    ? '?.?'
                                                    : result.reviewScore
                                                        .toString(),
                                            orElse: () => '?.?',
                                          ),
                                          style: textTheme.textHead32,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              _buildAnimatedOpacity(
                                hasValue: resultState.hasValue,
                                child: Text('점', style: textTheme.textTitle16),
                              ),
                            ],
                          ),
                          Gaps.v12,
                          _buildAnimatedOpacity(
                            hasValue: resultState.hasValue,
                            child: resultState.maybeWhen(
                              data: (result) => Row(
                                children: [
                                  Text(
                                    result.isReviewCompleted
                                        ? '최근 30일 기준 ${result.gender.toDisplayString(context)} 상위 ${result.genderTopRate.toStringAsFixed(0)}%'
                                        : '눈바디 측정 중... ${result.progressRate.toStringAsFixed(0)}% 완료',
                                    style: textTheme.textBody16,
                                  ),
                                  Gaps.h4,
                                  CustomCircularIndicator(
                                    size: Sizes.circularIndicatorSize18,
                                    strokeWidth:
                                        Sizes.circularIndicatorStrokeWidth2,
                                  ),
                                ],
                              ),
                              orElse: () =>
                                  const SizedBox(height: Sizes.spacing16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
              Gaps.v16,
              CustomWideButton(
                text: S.of(context).commonShare,
                isEnabled: resultState.maybeWhen(
                  data: (result) => result.isReviewCompleted,
                  orElse: () => false,
                ),
                onPressed: resultState.maybeWhen(
                  data: (result) => result.isReviewCompleted ? _onShare : null,
                  orElse: () => null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
