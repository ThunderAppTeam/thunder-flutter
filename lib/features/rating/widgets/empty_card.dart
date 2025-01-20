import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/theme/icon/thunder_icons_icons.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/wrappers/custom_pressable_wrapper.dart';
import 'package:thunder/generated/l10n.dart';

class EmptyCard extends StatelessWidget {
  final VoidCallback onRefresh;
  const EmptyCard({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    final textColor = ColorName.darkLabel2;

    return Card(
      color: ColorName.darkBackground2,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              ThunderIcons.noFile,
              size: Sizes.icon52,
              color: textColor,
            ),
            Gaps.v16,
            Text(
              S.of(context).ratingEmptyGuideText,
              style: textTheme.textBody18.copyWith(
                color: textColor,
                height: Sizes.fontHeight14,
              ),
              textAlign: TextAlign.center,
            ),
            Gaps.v32,
            CustomPressableWrapper(
              onPressed: onRefresh,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.spacing24,
                  vertical: Sizes.spacing14,
                ),
                decoration: BoxDecoration(
                  color: ColorName.white,
                  borderRadius: BorderRadius.circular(Sizes.radius8),
                ),
                child: Text(
                  S.of(context).commonRefresh,
                  style: textTheme.textBody18.copyWith(
                    color: ColorName.black,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
