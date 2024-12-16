import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:noon_body/core/router/routes.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_button.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_scaffold.dart';

class BirthdatePage extends StatefulWidget {
  const BirthdatePage({super.key});

  @override
  State<BirthdatePage> createState() => _BirthdatePageState();
}

class _BirthdatePageState extends State<BirthdatePage> {
  final _yearController = TextEditingController();
  final _monthController = TextEditingController();
  final _dayController = TextEditingController();

  bool get _isValid =>
      _yearController.text.length == 4 &&
      _monthController.text.length == 2 &&
      _dayController.text.length == 2;

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      title: '생년월일을\n입력해주세요',
      content: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              decoration: const InputDecoration(
                hintText: 'YYYY',
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: _monthController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              decoration: const InputDecoration(
                hintText: 'MM',
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: _dayController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              decoration: const InputDecoration(
                hintText: 'DD',
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
      bottomButton: OnboardingButton(
        text: '다음',
        onPressed: () => context.pushNamed(Routes.gender.name),
        isEnabled: _isValid,
      ),
    );
  }
}
