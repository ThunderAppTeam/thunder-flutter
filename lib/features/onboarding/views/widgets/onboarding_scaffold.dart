import 'package:flutter/material.dart';
import 'package:noon_body/core/extensions/text_style.dart';
import 'package:noon_body/core/theme/constants/gaps.dart';
import 'package:noon_body/core/theme/constants/styles.dart';
import 'package:noon_body/core/theme/constants/sizes.dart';
import 'package:noon_body/core/utils/theme_utils.dart';

class OnboardingScaffold extends StatelessWidget {
  final String title;
  final String? guideText;
  final Widget content;
  final Widget bottomButton;
  final bool showAppBar;

  const OnboardingScaffold({
    super.key,
    required this.title,
    this.guideText, // 안내 텍스트, 존재하면 gap과 함
    required this.content,
    required this.bottomButton,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              backgroundColor: Colors.transparent,
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.spacing20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: Sizes.spacing32),
                child: Text(
                  title,
                  style: textTheme.textHead24,
                ),
              ),
              content,
              if (guideText != null) ...[
                Gaps.v16,
                Text(
                  guideText!,
                  style: textTheme.textSubtitle14.withOpacity(Styles.opacity80),
                ),
              ],
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: Sizes.spacing8),
                child: bottomButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
