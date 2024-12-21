import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/router/routes.dart';
import 'package:thunder/core/router/safe_router.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:thunder/features/onboarding/providers/onboarding_provider.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_button.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_scaffold.dart';
import 'package:thunder/features/onboarding/views/widgets/onboarding_text_field.dart';
import 'package:thunder/generated/l10n.dart';

class BirthdatePage extends ConsumerStatefulWidget {
  const BirthdatePage({super.key});

  @override
  ConsumerState<BirthdatePage> createState() => _BirthdatePageState();
}

class _BirthdatePageState extends ConsumerState<BirthdatePage> {
  final _yearController = TextEditingController();
  final _monthController = TextEditingController();
  final _dayController = TextEditingController();
  // FocusNode
  final _yearFocus = FocusNode();
  final _monthFocus = FocusNode();
  final _dayFocus = FocusNode();

  bool get _isButtonEnabled {
    return _yearController.text.length == 4 &&
        _monthController.text.length == 2 &&
        _dayController.text.length == 2;
  }

  bool get _isAgeValid {
    final year = int.tryParse(_yearController.text);
    final month = int.tryParse(_monthController.text);
    final day = int.tryParse(_dayController.text);

    if (year == null || month == null || day == null) return false;

    final birthDate = DateTime(year, month, day);
    final today = DateTime.now();
    final age = today.year - birthDate.year;
    final monthDiff = today.month - birthDate.month;

    // 생일이 아직 지나지 않았다면 나이에서 1을 빼줌
    if (monthDiff < 0 || (monthDiff == 0 && today.day < birthDate.day)) {
      return age - 1 >= 18;
    }
    return age >= 18;
  }

  void _handleNextPress() {
    if (_isAgeValid) {
      SafeRouter.pushNamed(context, Routes.gender.name);
    } else {
      _showAgeRestrictionBottomSheet();
    }
  }

  void _showAgeRestrictionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => CustomBottomSheet(
        title: '서비스 이용가능 연령이 아니에요',
        subtitle: '만 18세 미만은 썬더를 이용하실 수 없어요. 나중에 다시 만나요.',
        buttonText: '확인',
      ),
    );
  }

  void _fieldFocusChange(String value, int maxLength, FocusNode currentFocus,
      FocusNode? nextFocus) {
    if (value.length == maxLength) {
      currentFocus.unfocus();
      nextFocus?.requestFocus();
    }
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();

    _yearFocus.dispose();
    _monthFocus.dispose();
    _dayFocus.dispose();

    super.dispose();
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required int maxLength,
    required int flex,
    required FocusNode? nextFocus,
  }) {
    return Expanded(
      flex: flex,
      child: OnboardingTextField(
        controller: controller,
        focusNode: focusNode,
        hintText: hintText,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(maxLength),
        ],
        onChanged: (value) {
          setState(() {});
          _fieldFocusChange(value, maxLength, focusNode, nextFocus);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nickname = ref.read(onboardingProvider).nickname!;
    final textTheme = getTextTheme(context);
    final divider = [
      Gaps.h16,
      Text('/', style: textTheme.textHead24),
      Gaps.h16,
    ];
    return OnboardingScaffold(
      title: S.of(context).birthdateTitle(nickname),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildDateField(
            controller: _yearController,
            focusNode: _yearFocus,
            nextFocus: _monthFocus,
            hintText: 'YYYY',
            maxLength: 4,
            flex: 4,
          ),
          ...divider,
          _buildDateField(
            controller: _monthController,
            focusNode: _monthFocus,
            nextFocus: _dayFocus,
            hintText: 'MM',
            maxLength: 2,
            flex: 3,
          ),
          ...divider,
          _buildDateField(
            controller: _dayController,
            focusNode: _dayFocus,
            hintText: 'DD',
            maxLength: 2,
            flex: 3,
            nextFocus: null,
          ),
          Gaps.h16,
          Expanded(flex: 3, child: SizedBox()),
        ],
      ),
      guideText: S.of(context).birthdateGuideText,
      bottomButton: OnboardingButton(
        text: S.of(context).commonNext,
        onPressed: _handleNextPress,
        isEnabled: _isButtonEnabled,
      ),
    );
  }
}
