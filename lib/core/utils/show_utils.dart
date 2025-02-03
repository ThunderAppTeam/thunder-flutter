import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thunder/core/constants/app_const.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/widgets/bottom_sheets/action_bottom_sheet.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:thunder/core/widgets/bottom_sheets/survey_bottom_sheet.dart';
import 'package:thunder/core/widgets/dialog/custom_alert_dialog.dart';
import 'package:thunder/generated/l10n.dart';

void showActionBottomSheet(
    BuildContext context, List<ModalActionItem> actions) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    useRootNavigator: true,
    builder: (context) => ActionBottomSheet(actions: actions),
  );
}

void showCommonUnknownErrorBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    builder: (context) => CustomBottomSheet(
      title: S.of(context).commonErrorUnknownTitle,
      subtitle: S.of(context).commonErrorUnknownSubtitle(AppConst.supportEmail),
    ),
  );
}

void showCustomBottomSheet(
  BuildContext context, {
  required String title,
  required String subtitle,
}) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    builder: (context) => CustomBottomSheet(
      title: title,
      subtitle: subtitle,
    ),
  );
}

Future<SurveyResult?> showSurveyBottomSheet(
  BuildContext context, {
  required String title,
  required List<String> options,
  required String buttonText,
  FutureOr<void> Function()? onButtonTap,
  bool hasOtherOption = false,
}) async {
  final mediaQuery = MediaQuery.of(context);
  final devicePixelRatio = mediaQuery.devicePixelRatio;
  final safePadding =
      WidgetsBinding.instance.platformDispatcher.implicitView!.padding.top /
          devicePixelRatio;

  final result = await showModalBottomSheet<SurveyResult>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    constraints: BoxConstraints(
      maxHeight: mediaQuery.size.height - (safePadding + Sizes.appBarHeight48),
    ),
    builder: (context) => SurveyBottomSheet(
      title: title,
      options: options,
      buttonText: buttonText,
      onButtonTap: onButtonTap,
      hasOtherOption: hasOtherOption,
    ),
  );
  return result;
}

Future<bool?> showAlertDialog(
  BuildContext context, {
  required String title,
  required String subtitle,
  required String confirmText,
  String? cancelText,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => CustomAlertDialog(
      title: title,
      subtitle: subtitle,
      confirmText: confirmText,
      cancelText: cancelText ?? S.of(context).commonCancel,
    ),
  );
  return confirmed;
}
