import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/assets.gen.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/theme/icon/thunder_icons_icons.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:thunder/core/widgets/buttons/custom_wide_button.dart';
import 'package:thunder/core/widgets/custom_circular_indicator.dart';
import 'package:thunder/core/widgets/thunder_network_image.dart';
import 'package:thunder/features/body_check/view_models/body_check_result_view_model.dart';
import 'package:thunder/generated/l10n.dart';

class BodyCheckResultPage extends ConsumerWidget {
  final int bodyPhotoId;
  final bool fromUpload;

  const BodyCheckResultPage({
    super.key,
    required this.bodyPhotoId,
    this.fromUpload = false,
  });

  String _getResultText(double genderTopPercent) {
    return '최근 30일 기준 상위 ${genderTopPercent.round()}%';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultState = ref.watch(bodyCheckResultProvider(bodyPhotoId));
    final textTheme = getTextTheme(context);
    ref.listen(bodyCheckResultProvider(bodyPhotoId), (previous, next) {
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
            if (fromUpload)
              CustomAppBarAction(
                type: CustomAppBarActionType.icon,
                icon: ThunderIcons.closeSquareLight,
                onTap: () {
                  ref
                      .read(safeRouterProvider)
                      .goNamed(context, Routes.home.name);
                },
              ),
          ],
          showBackButton: !fromUpload,
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            top: Sizes.spacing16,
            left: Sizes.spacing16,
            right: Sizes.spacing16,
            bottom: Sizes.spacing8,
          ),
          child: resultState.when(
            data: (result) {
              String pointText = result.isReviewCompleted
                  ? result.totalScore.toStringAsFixed(1)
                  : '?.?';
              String resultText = result.isReviewCompleted
                  ? _getResultText(result.genderTopPercent)
                  : '눈바디 측정 중...';
              return Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Sizes.radius16),
                          ),
                          child: ThunderNetworkImage(imageUrl: result.imageUrl),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  ColorName.black.withOpacity(0.0),
                                  ColorName.black.withOpacity(0.25),
                                  ColorName.black.withOpacity(0.5),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.only(
                              top: Sizes.spacing8,
                              left: Sizes.spacing16,
                              right: Sizes.spacing16,
                              bottom: Sizes.spacing24,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Assets.images.logos.thunderSymbolW.svg(),
                                    Gaps.h4,
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: pointText,
                                            style: textTheme.textHead32,
                                          ),
                                          TextSpan(
                                            text: '점',
                                            style: textTheme.textTitle16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Gaps.v12,
                                Row(
                                  children: [
                                    Text(
                                      resultText,
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gaps.v16,
                  CustomWideButton(
                    text: S.of(context).commonShare,
                    onPressed: _onShare,
                    isEnabled: result.isReviewCompleted,
                  ),
                ],
              );
            },
            error: (error, stack) {
              return const Center(
                child: Text('결과를 불러오는데 실패했습니다.'),
              );
            },
            loading: () => const Center(child: CustomCircularIndicator()),
          ),
        ),
      ),
    );
  }
}
