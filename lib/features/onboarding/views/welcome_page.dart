import 'package:flutter/material.dart';
import 'package:noon_body/core/theme/gaps.dart';
import 'package:noon_body/core/theme/gen/assets.gen.dart';
import 'package:noon_body/core/theme/gen/colors.gen.dart';

import 'package:noon_body/core/theme/sizes.dart';
import 'package:noon_body/core/utils/theme_utils.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_button.dart';
import 'package:noon_body/generated/l10n.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.spacing20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: Sizes.spacing40,
                ),
                child: Text(
                  S.of(context).welcomeTitle,
                  style: textTheme.textHead32,
                  textAlign: TextAlign.center,
                ),
              ),
              Column(
                children: [
                  // TODO-UI: 이미지 사이즈 지정
                  SizedBox(
                    width: 322,
                    height: 387,
                    child: Assets.images.welcomeMain.image(),
                  ),
                  Gaps.v32,
                  // TODO-UI: 텍스트 사이즈를 지정해야함, 혹은 줄바꿈 로직 추가
                  Text(
                    S.of(context).welcomeDescription,
                    style: textTheme.textHead24,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                children: [
                  OnboardingButton(
                    text: S.of(context).welcomeStart,
                    onPressed: () => {},
                  ),
                  Gaps.v8,
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: Sizes.spacing16),
                    // 두가지 색깔이 다른 텍스트 (이미 계정이 있나요? 로그인), 로그인은 색상이 다르며, 눌렀을 때 로그인 페이지로 이동
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).welcomeAlreadyAccount,
                          style: textTheme.textTitle16,
                        ),
                        Gaps.h8,
                        GestureDetector(
                          // TODO-Feat: 로그인 페이지로 이동
                          onTap: () => {},
                          child: Text(
                            S.of(context).commonLogin,
                            style: textTheme.textTitle16.copyWith(
                              color: ColorName.accentRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
