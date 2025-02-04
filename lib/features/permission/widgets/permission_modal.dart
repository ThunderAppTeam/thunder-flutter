import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/features/permission/widgets/permission_button.dart';

enum PermissionModalButtonDirection {
  horizontal,
  vertical,
}

class PermissionModal extends StatelessWidget {
  final double modalWidth;

  final String title;
  final String description;
  final String denyText;
  final String allowText;
  final PermissionModalButtonDirection buttonDirection;
  final VoidCallback onTapDeny;
  final VoidCallback onTapAllow;

  const PermissionModal({
    super.key,
    required this.modalWidth,
    required this.title,
    required this.description,
    required this.denyText,
    required this.allowText,
    required this.buttonDirection,
    required this.onTapDeny,
    required this.onTapAllow,
  });

  Widget _buildEmoji() {
    return Transform.translate(
      offset: const Offset(0, 30),
      child: IgnorePointer(child: Text('👆', style: TextStyle(fontSize: 32))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    final borderWidth = 0.33;

    return Container(
      padding: const EdgeInsets.only(top: 19),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.radius14),
        color: ColorName.darkBackground4,
      ),
      width: modalWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: Sizes.spacing16,
              right: Sizes.spacing16,
              bottom: Sizes.spacing16,
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: textTheme.customStyle.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    height: Sizes.lineHeight22 / 17,
                    letterSpacing: -0.43,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.v4,
                Text(
                  description,
                  style: textTheme.customStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    height: Sizes.lineHeight18 / 13,
                    letterSpacing: -0.08,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Gaps.v2,
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: ColorName.gray300,
                  width: borderWidth,
                ),
              ),
            ),
            child: switch (buttonDirection) {
              PermissionModalButtonDirection.horizontal => Row(
                  children: [
                    Expanded(
                      child: PermissionButton(
                        text: denyText,
                        onTap: onTapDeny,
                        isAllow: false,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(Sizes.radius14),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          PermissionButton(
                            text: allowText,
                            onTap: onTapAllow,
                            isAllow: true,
                            border: Border(
                              right: BorderSide(
                                color: ColorName.gray300,
                                width: borderWidth,
                              ),
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(Sizes.radius14),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: _buildEmoji(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              PermissionModalButtonDirection.vertical => Column(
                  children: [
                    PermissionButton(
                      text: denyText,
                      onTap: onTapDeny,
                      isAllow: false,
                      border: Border(
                        bottom: BorderSide(
                          color: ColorName.gray300,
                          width: borderWidth,
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        PermissionButton(
                          text: allowText,
                          onTap: onTapAllow,
                          isAllow: true,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(Sizes.radius14),
                            bottomRight: Radius.circular(Sizes.radius14),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: _buildEmoji(),
                        ),
                      ],
                    ),
                  ],
                ),
            },
          ),
        ],
      ),
    );
  }
}
