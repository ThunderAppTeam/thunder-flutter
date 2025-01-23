import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/theme/icon/thunder_icons_icons.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/wrappers/custom_pressable_wrapper.dart';

class EmptyWidget extends StatelessWidget {
  final VoidCallback onButtonTap;
  final String guideText;
  final String buttonText;
  const EmptyWidget({
    super.key,
    required this.onButtonTap,
    required this.guideText,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    final textColor = ColorName.darkLabel2;

    return Center(
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
            guideText,
            style: textTheme.textBody18.copyWith(
              color: textColor,
              height: Sizes.fontHeight14,
            ),
            textAlign: TextAlign.center,
          ),
          Gaps.v32,
          CustomPressableWrapper(
            child: Material(
              color: ColorName.white,
              borderRadius: BorderRadius.circular(Sizes.radius8),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: onButtonTap,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizes.spacing24,
                    vertical: Sizes.spacing14,
                  ),
                  child: Text(
                    buttonText,
                    style: textTheme.textBody18.copyWith(
                      color: ColorName.black,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
