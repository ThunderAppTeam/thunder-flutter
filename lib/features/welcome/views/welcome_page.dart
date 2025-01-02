import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';

import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/gen/assets.gen.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/buttons/custom_wide_button.dart';
import 'package:thunder/generated/l10n.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  void _onStartPressed(BuildContext context, WidgetRef ref) {
    SafeRouter.pushNamed(context, Routes.onboarding.name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = getTextTheme(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: Sizes.spacing40,
                        left: Sizes.spacing20,
                        right: Sizes.spacing20,
                        bottom: Sizes.spacing8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.of(context).welcomeTitle,
                            style: textTheme.textHead32,
                            textAlign: TextAlign.center,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                // TODO-UI: 이미지 사이즈 지정
                                width: 322,
                                height: 387,
                                child: Assets.images.welcomeMain.image(),
                              ),
                              Gaps.v32,
                              Text(
                                S.of(context).welcomeDescription,
                                style: textTheme.textHead24,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: Sizes.spacing32),
                            child: CustomWideButton(
                              text: S.of(context).welcomeStart,
                              onPressed: () => _onStartPressed(context, ref),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
