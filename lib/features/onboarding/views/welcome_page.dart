import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thunder/core/router/routes.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/gen/assets.gen.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_button.dart';
import 'package:thunder/generated/l10n.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void _onStartPressed(BuildContext context) {
    context.push(Routes.phoneNumber.path);
  }

  void _onLoginTap() {
    // pressed가 아닌 이유, 바로 tap했을 시에 발생하는 이벤트
    // TODO-Feat: 로그인 버튼 눌렀을 때 로직 추가
  }

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
                    onPressed: () => _onStartPressed(context),
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
                          onTap: _onLoginTap,
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
