import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/buttons/custom_wide_button.dart';
import 'package:thunder/generated/l10n.dart';

class ModalActionItem {
  final String text;
  final VoidCallback onTap;

  ModalActionItem({
    required this.text,
    required this.onTap,
  });
}

class ActionBottomSheet extends StatelessWidget {
  final List<ModalActionItem> actions;
  final String? cancelText;
  final VoidCallback? onCancel;
  const ActionBottomSheet({
    super.key,
    required this.actions,
    this.cancelText,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: Sizes.spacing24,
          left: Sizes.spacing16,
          right: Sizes.spacing16,
          bottom: Sizes.spacing8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionList(context),
            Gaps.v16,
            CustomWideButton(
              text: cancelText ?? S.of(context).commonCancel,
              onPressed: onCancel ?? () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionList(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: ColorName.white,
        borderRadius: BorderRadius.circular(Sizes.radius16),
      ),
      child: Column(
        children: actions.map((action) {
          final isLast = action == actions.last;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                action.onTap();
              },
              child: Container(
                decoration: BoxDecoration(
                  border: isLast
                      ? null
                      : Border(
                          bottom: BorderSide(
                            color: ColorName.dividerGray,
                            width: Sizes.borderWidth1,
                          ),
                        ),
                ),
                height: 60,
                child: Center(
                  child: Text(
                    action.text,
                    style: getTextTheme(context)
                        .textBody18
                        .copyWith(color: ColorName.black),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
