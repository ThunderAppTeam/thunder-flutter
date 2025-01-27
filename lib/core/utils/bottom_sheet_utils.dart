import 'package:flutter/material.dart';
import 'package:thunder/core/widgets/bottom_sheets/action_bottom_sheet.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:thunder/generated/l10n.dart';

void showActionBottomSheet(
    BuildContext context, List<ModalActionItem> actions) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    useRootNavigator: true,
    builder: (context) => ActionBottomSheet(
      actions: actions,
    ),
  );
}

void showCommonUnknownErrorBottomSheet(BuildContext context) {
  showBottomSheet(
    context: context,
    builder: (context) => CustomBottomSheet(
      title: S.of(context).commonErrorUnknownTitle,
      subtitle: S.of(context).commonErrorUnknownSubtitle,
    ),
  );
}
