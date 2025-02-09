import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/utils/show_utils.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/features/auth/models/data/deletion_reason_data.dart';
import 'package:thunder/features/auth/providers/delete_account_provider.dart';
import 'package:thunder/features/member/view_models/member_view_model.dart';
import 'package:thunder/features/settings/widgets/settings_list_tile.dart';
import 'package:thunder/generated/l10n.dart';

class SettingsAccountPage extends ConsumerStatefulWidget {
  const SettingsAccountPage({super.key});

  @override
  ConsumerState<SettingsAccountPage> createState() =>
      _SettingsAccountPageState();
}

class _SettingsAccountPageState extends ConsumerState<SettingsAccountPage> {
  late final List<DeletionReasonData> _deletionReasons;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _deletionReasons =
          await ref.read(deleteAccountProvider.notifier).getDeletionReasons();
    });
  }

  void _onDeleteAccountTap(BuildContext context) async {
    final options = _deletionReasons.map((e) => e.description).toList();

    final result = await showSurveyBottomSheet(
      context,
      title: S.of(context).settingsAccountDelete,
      options: options,
      buttonText: S.of(context).settingsAccountDelete,
      hasOtherOption: true,
      onBeforeConfirm: () => _surveyButtonTap(context),
    );
    if (result == null) return;
    final reason = _deletionReasons[result.index];
    await ref
        .read(deleteAccountProvider.notifier)
        .deleteAccount(reason, result.otherOptionText);
    if (context.mounted) {
      ref.read(safeRouterProvider).goToWelcome(context);
    }
  }

  Future<bool?> _surveyButtonTap(BuildContext context) async {
    final confirmed = await showAlertDialog(
      context,
      title: S.of(context).deleteAccountConfirmTitle,
      subtitle: S.of(context).deleteAccountConfirmSubtitle,
      confirmText: S.of(context).commonDelete,
    );
    return confirmed;
  }

  @override
  Widget build(BuildContext context) {
    final memberDataState = ref.watch(memberDataProvider);
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).settingsAccount),
      body: memberDataState.when(
        data: (data) => Column(
          children: [
            SettingsListTile(
              title: S.of(context).settingsAccountNickname,
              trailing: SettingsTrailing.text(data.nickname),
            ),
            SettingsListTile(
              title: S.of(context).settingsAccountPhoneNumber,
              trailing: SettingsTrailing.text(data.mobileNumber),
            ),
            SettingsListTile(
              title: S.of(context).settingsAccountJoinedDate,
              trailing: SettingsTrailing.text(
                  DateFormat.yMMMd().format(data.registeredAt)),
            ),
            SettingsListTile(
              title: S.of(context).settingsAccountDelete,
              onTap: () => _onDeleteAccountTap(context),
              isGray: true,
            ),
          ],
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => const SizedBox.shrink(),
      ),
    );
  }
}
