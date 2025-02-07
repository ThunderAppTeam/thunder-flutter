import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thunder/core/services/log_service.dart';
import 'package:thunder/core/utils/show_utils.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/features/settings/widgets/settings_list_tile.dart';
import 'package:thunder/generated/l10n.dart';

class SettingsAccountPage extends StatelessWidget {
  const SettingsAccountPage({super.key});

  void _onDeleteAccountTap(BuildContext context) async {
    final options = [
      S.of(context).deleteAccountOptionLessInterest,
      S.of(context).deleteAccountOptionUnreliableResult,
      S.of(context).deleteAccountOptionLongProcess,
      S.of(context).deleteAccountOptionNoFeature,
      S.of(context).deleteAccountOptionServiceError,
      S.of(context).deleteAccountOptionUncomfortable,
      S.of(context).deleteAccountOptionBetterService,
      S.of(context).surveyOtherOption,
    ];

    final result = await showSurveyBottomSheet(
      context,
      title: S.of(context).settingsAccountDelete,
      options: options,
      buttonText: S.of(context).settingsAccountDelete,
      hasOtherOption: true,
      onButtonTap: () => _surveyButtonTap(context),
    );
    LogService.trace('delete account option: $result');
    // TODO: 계정 삭제 요청 접수
  }

  void _surveyButtonTap(BuildContext context) async {
    final confirmed = await showAlertDialog(
      context,
      title: S.of(context).deleteAccountConfirmTitle,
      subtitle: S.of(context).deleteAccountConfirmSubtitle,
      confirmText: S.of(context).commonDelete,
    );
    if (confirmed == true) {
      // TODO: 계정 삭제 요청 접수
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).settingsAccount),
      body: Column(
        children: [
          SettingsListTile(
            title: S.of(context).settingsAccountNickname,
            trailing: SettingsTrailing.text("닉네임"),
          ),
          SettingsListTile(
            title: S.of(context).settingsAccountPhoneNumber,
            trailing: SettingsTrailing.text("010-9005-9948"),
          ),
          SettingsListTile(
            title: S.of(context).settingsAccountJoinedDate,
            trailing: SettingsTrailing.text(
                DateFormat.yMMMd().format(DateTime.now())),
          ),
          SettingsListTile(
            title: S.of(context).settingsAccountDelete,
            onTap: () => _onDeleteAccountTap(context),
            isGray: true,
          ),
        ],
      ),
    );
  }
}
