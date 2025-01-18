import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/constants/image_consts.dart';
import 'package:thunder/core/enums/gender.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/constants/styles.dart';
import 'package:thunder/core/theme/gen/assets.gen.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:thunder/core/widgets/buttons/custom_wide_button.dart';
import 'package:thunder/core/widgets/custom_circular_indicator.dart';
import 'package:thunder/features/body_check/models/body_check_state.dart';
import 'package:thunder/features/body_check/view_models/body_check_view_model.dart';
import 'package:thunder/generated/l10n.dart';

class BodyCheckWaitingPage extends ConsumerStatefulWidget {
  const BodyCheckWaitingPage({super.key});

  @override
  ConsumerState<BodyCheckWaitingPage> createState() =>
      _BodyCheckWaitingPageState();
}

class _BodyCheckWaitingPageState extends ConsumerState<BodyCheckWaitingPage> {
  String _getResultText(BodyCheckState bodyCheckState) {
    final gender = bodyCheckState.gender == Gender.male ? '남성' : '여성';
    final genderPercent = bodyCheckState.genderPercent.round();

    return '최근 30일 기준 $gender 상위 $genderPercent%';
  }

  void _onError() {
    showModalBottomSheet(
      context: context,
      builder: (context) => CustomBottomSheet(
        title: S.of(context).commonErrorUnknownTitle,
        subtitle: S.of(context).commonErrorUnknownSubtitle,
      ),
    );
  }

  void _onShare() {
    // TODO: 공유하기, 임시로 process 초기화 버튼으로 사용
    ref.read(bodyCheckProvider.notifier).startFakeProgress();
  }

  @override
  Widget build(BuildContext context) {
    final bodyCheckState = ref.watch(bodyCheckProvider);
    ref.listen(bodyCheckProvider, (prev, next) {
      if (prev?.error == null && next.error != null) {
        _onError();
      }
    });
    final textTheme = getTextTheme(context);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: '내 눈바디',
          actions: [
            CustomAppBarAction(
              icon: Icons.more_horiz,
              onTap: () {},
            ),
            CustomAppBarAction(
              icon: Icons.close,
              onTap: () {
                // 홈으로 이동
                ref.read(safeRouterProvider).goNamed(context, Routes.home.name);
              },
            ),
          ],
          showBackButton: false,
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
                child: bodyCheckState.isUploading
                    ? const CustomCircularIndicator()
                    : AspectRatio(
                        aspectRatio: ImageConsts.aspectRatio,
                        child: Stack(
                          children: [
                            Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Styles.radius16),
                              ),
                              child: Image.network(
                                bodyCheckState.imageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
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
                                        Assets.images.logos.thunderSymbolW
                                            .svg(),
                                        Gaps.h4,
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: bodyCheckState
                                                    .currentScore
                                                    .toStringAsFixed(1),
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
                                    if (bodyCheckState.isFinished)
                                      Text(
                                        _getResultText(bodyCheckState),
                                        style: textTheme.textBody16,
                                      )
                                    else
                                      Text(
                                        '눈바디 측정 중... ${bodyCheckState.progress.round()}% 완료',
                                        style: textTheme.textBody16,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              Gaps.v16,
              CustomWideButton(
                text: '공유하기',
                onPressed: _onShare,
                isEnabled: bodyCheckState.isFinished,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
