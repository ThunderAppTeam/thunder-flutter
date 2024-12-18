import 'package:flutter/material.dart';
import 'package:noon_body/core/theme/constants/gaps.dart';
import 'package:noon_body/core/theme/constants/sizes.dart';
import 'package:noon_body/core/theme/gen/colors.gen.dart';
import 'package:noon_body/core/utils/theme_utils.dart';
import 'package:noon_body/core/widgets/bottom_sheets/custom_bottom_sheet.dart';

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
  String _getTermLabel(Terms term) {
    switch (term) {
      case Terms.service:
        return '서비스 이용약관';
      case Terms.privacy:
        return '개인정보 수집 및 이용';
      case Terms.marketing:
        return '마케팅 정보 수신 동의';
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
            '모두 동의',
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
            (term.isRequired ? '(필수) ' : '(선택) ') + label,
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
      title: '썬더를 이용하려면 동의가 필요해요',
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
                  label: _getTermLabel(term),
                  value: _agreements[term] ?? false,
                  onChanged: (value) => _toggleTerm(term, value),
                ),
                if (!isLastItem) Gaps.v24,
              ],
            );
          }),
        ],
      ),
      buttonText: '동의하고 시작하기',
      onPressed: _isValid ? _handleAgree : null,
      isEnabled: _isValid,
    );
  }
}
