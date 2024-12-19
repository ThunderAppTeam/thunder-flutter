import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:thunder/generated/l10n.dart';

enum Terms {
  service(true),
  privacy(true),
  marketing(false);

  final bool isRequired;

  const Terms(this.isRequired);
}

class TermsBottomSheet extends StatefulWidget {
  final VoidCallback? onAgreed;

  const TermsBottomSheet({
    super.key,
    this.onAgreed,
  });

  @override
  State<TermsBottomSheet> createState() => _TermsBottomSheetState();
}

class _TermsBottomSheetState extends State<TermsBottomSheet> {
  String _getTermLabel(Terms term, BuildContext context) {
    switch (term) {
      case Terms.service:
        return S.of(context).termsService;
      case Terms.privacy:
        return S.of(context).termsPrivacy;
      case Terms.marketing:
        return S.of(context).termsMarketing;
    }
  }

  final Map<Terms, bool> _agreements = {
    for (var term in Terms.values) term: false
  };

  bool get _isAllChecked => _agreements.values.every((isChecked) => isChecked);

  bool get _isValid => Terms.values
      .where((term) => term.isRequired)
      .every((term) => _agreements[term] == true);

  void _toggleAll(bool? value) {
    if (value == null) return;
    setState(() {
      for (var term in Terms.values) {
        _agreements[term] = value;
      }
    });
  }

  void _toggleTerm(Terms term, bool? value) {
    if (value == null) return;
    setState(() {
      _agreements[term] = value;
    });
  }

  void _handleAgree() {
    Navigator.pop(context, true);
    widget.onAgreed?.call();
  }

  Widget _buildAllAgreeCheckbox() {
    final textTheme = getTextTheme(context);
    return Row(
      children: [
        SizedBox(
          width: Sizes.icon20,
          height: Sizes.icon20,
          child: Checkbox(
            activeColor: ColorName.black,
            checkColor: ColorName.white,
            value: _isAllChecked,
            onChanged: _toggleAll,
            shape: const CircleBorder(),
          ),
        ),
        Gaps.h12,
        Expanded(
          child: Text(
            S.of(context).termsAllAgree,
            style: textTheme.textTitle18.copyWith(
              color: ColorName.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermItem({
    required Terms term,
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    final textTheme = getTextTheme(context);
    return Row(
      children: [
        // 체크 영역
        GestureDetector(
          onTap: () => onChanged(!value),
          child: Icon(
            Icons.check,
            size: Sizes.icon24,
            color: value ? ColorName.black : ColorName.gray300,
          ),
        ),
        Gaps.h12,
        // 텍스트 영역
        Expanded(
          child: Text(
            (term.isRequired
                    ? '(${S.of(context).termsRequired}) '
                    : '(${S.of(context).termsOptional}) ') +
                label,
            style: textTheme.textBody16.copyWith(
              color: ColorName.black,
            ),
          ),
        ),
        // 상세보기 영역
        GestureDetector(
          onTap: () {
            // TODO: 약관 상세 페이지로 이동
            debugPrint('Show details for ${term.name}');
          },
          child: Icon(
            Icons.chevron_right,
            color: ColorName.gray500,
            size: Sizes.icon24,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: S.of(context).termsTitle,
      content: Column(
        children: [
          _buildAllAgreeCheckbox(),
          Gaps.v32,
          ...Terms.values.map((term) {
            final isLastItem = term == Terms.values.last;
            return Column(
              children: [
                _buildTermItem(
                  term: term,
                  label: _getTermLabel(term, context),
                  value: _agreements[term] ?? false,
                  onChanged: (value) => _toggleTerm(term, value),
                ),
                if (!isLastItem) Gaps.v24,
              ],
            );
          }),
        ],
      ),
      buttonText: S.of(context).termsConfirm,
      onPressed: _isValid ? _handleAgree : null,
      isEnabled: _isValid,
    );
  }
}
