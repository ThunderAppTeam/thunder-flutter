import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/custom_circular_indicator.dart';
import 'package:thunder/generated/l10n.dart';

class LoadingCard extends StatelessWidget {
  const LoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    return Card(
      color: ColorName.darkBackground2,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).commonSearching,
              style: textTheme.textTitle18,
            ),
            Gaps.v8,
            CustomCircularIndicator(),
          ],
        ),
      ),
    );
  }
}
