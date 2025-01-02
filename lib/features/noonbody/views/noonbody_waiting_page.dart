import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/enums/gender.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/constants/styles.dart';
import 'package:thunder/core/theme/gen/assets.gen.dart';
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
          actionIcon: Icons.more_horiz,
          onAction: () {},
          onBack: () =>
              SafeRouter.goNamed(context, Routes.home.name, extra: true),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.spacing16),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Styles.radius16),
                  ),
                  child: Stack(
                    children: [
                      Image.file(
                        File(widget.imagePath),
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                        bottom: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: Sizes.spacing8,
                            left: Sizes.spacing16,
                            right: Sizes.spacing16,
                            bottom: Sizes.spacing24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Assets.images.thunderSymbolW.svg(),
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
                                  '눈바디 측정중... ${noonbodyState.progress.round()}% 완료',
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
                  // test 용 재 업로드
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
