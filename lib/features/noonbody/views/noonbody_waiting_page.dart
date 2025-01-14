import 'dart:io';

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
import 'package:thunder/core/widgets/buttons/custom_wide_button.dart';
import 'package:thunder/features/noonbody/models/noonbody_state.dart';
import 'package:thunder/features/noonbody/view_models/noonbody_view_model.dart';

class NoonbodyWaitingPage extends ConsumerStatefulWidget {
  final String imagePath;

  const NoonbodyWaitingPage({super.key, required this.imagePath});

  @override
  ConsumerState<NoonbodyWaitingPage> createState() =>
      _NoonbodyWaitingPageState();
}

class _NoonbodyWaitingPageState extends ConsumerState<NoonbodyWaitingPage> {
  String _getResultText(NoonbodyState noonbodyState) {
    final ageGroup = noonbodyState.age ~/ 10 * 10;
    final gender = noonbodyState.gender == Gender.male ? '남성' : '여성';
    final genderPercent = noonbodyState.genderPercent.round();
    final percent = noonbodyState.percent.round();
    return '$ageGroup대 $gender 상위 $genderPercent% | 전체 상위 $percent%';
  }

  @override
  Widget build(BuildContext context) {
    final noonbodyState = ref.watch(noonbodyProvider);
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
                // 이미지 삭제
                File(widget.imagePath).delete();
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
                child: noonbodyState.isUploading
                    ? const Center(child: CircularProgressIndicator())
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
                              child: Image.file(
                                File(widget.imagePath),
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
                                                text: noonbodyState.currentScore
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
                                    if (noonbodyState.isFinished)
                                      Text(
                                        _getResultText(noonbodyState),
                                        style: textTheme.textBody16,
                                      )
                                    else
                                      Text(
                                        '눈바디 측정 중... ${noonbodyState.progress.round()}% 완료',
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
                onPressed: () {
                  ref
                      .read(noonbodyProvider.notifier)
                      .uploadImage(widget.imagePath);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
