import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/constants/time_consts.dart';
import 'package:thunder/core/theme/constants/styles.dart';
import 'package:thunder/core/theme/gen/assets.gen.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/buttons/custom_wide_button.dart';
import 'package:thunder/generated/l10n.dart';
import 'package:thunder/features/welcome/controllers/welcome_controller.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  void _onStartPressed(BuildContext context, WidgetRef ref) {
    ref.read(safeRouterProvider).pushNamed(context, Routes.onboarding.name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = getTextTheme(context);
    final controller = ref.read(welcomeControllerProvider.notifier);
    final currentImageIndex = ref.watch(welcomeControllerProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // 배경 이미지 애니메이션
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: TimeConsts.welcomeImageTransitionDuration,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: Container(
                  key: ValueKey<int>(currentImageIndex),
                  child: Opacity(
                    opacity: Styles.opacity70,
                    child: controller.images[currentImageIndex].image(
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
            // 콘텐츠
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: Sizes.spacing20,
                  right: Sizes.spacing20,
                  bottom: Sizes.spacing24,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Sizes.spacing56,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Assets.images.logos.thunderLogotypeW
                                .svg(height: Sizes.spacing32),
                            Text(
                              S.of(context).welcomeDescription,
                              style: textTheme.textHead24,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomWideButton(
                      text: S.of(context).welcomeStart,
                      onPressed: () => _onStartPressed(context, ref),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
