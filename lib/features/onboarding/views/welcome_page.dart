import 'package:flutter/material.dart';
import 'package:thunder/core/router/routes.dart';
import 'package:thunder/core/router/safe_router.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/gen/assets.gen.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_button.dart';
import 'package:thunder/generated/l10n.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void _onStartPressed(BuildContext context) {
    SafeRouter.pushNamed(context, Routes.phoneNumber.name);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
