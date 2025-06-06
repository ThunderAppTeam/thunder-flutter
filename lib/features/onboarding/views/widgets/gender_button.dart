import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/constants/styles.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';

class GenderButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Styles.duration200,
        height: Sizes.buttonHeight60,
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorName.white,
            width: Sizes.borderWidth2,
          ),
          borderRadius: BorderRadius.circular(Sizes.radius16),
          color: isSelected ? ColorName.white : null,
        ),
        child: Center(
          child: Text(
            label,
            style: textTheme.textTitle18.copyWith(
              color: isSelected ? ColorName.black : ColorName.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
