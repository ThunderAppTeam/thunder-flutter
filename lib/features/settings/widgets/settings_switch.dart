import 'package:flutter/material.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/theme/constants/sizes.dart';

class SettingsSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitch({
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Sizes.switchWidth,
      height: Sizes.switchHeight,
      child: Center(
        child: GestureDetector(
          onTap: () => onChanged(!value),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: Sizes.switchTrackWidth,
            height: Sizes.switchTrackHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.5),
              color: value ? ColorName.white : ColorName.darkGray3,
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 100),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: Sizes.switchThumbSize,
                height: Sizes.switchThumbSize,
                margin:
                    EdgeInsets.symmetric(horizontal: Sizes.switchThumbMargin),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value ? ColorName.black : ColorName.darkSwitchInactive,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
