import 'package:flutter/material.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_button.dart';
import 'package:noon_body/features/onboarding/views/widgets/onboarding_scaffold.dart';

class GenderPage extends StatefulWidget {
  const GenderPage({super.key});

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  String? _selectedGender;
  bool _agreedToTerms = false;

  bool get _isValid => _selectedGender != null && _agreedToTerms;

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      title: '성별을\n선택해주세요',
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: _GenderButton(
                    label: '남성',
                    isSelected: _selectedGender == '남성',
                    onTap: () => setState(() => _selectedGender = '남성'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _GenderButton(
                    label: '여성',
                    isSelected: _selectedGender == '여성',
                    onTap: () => setState(() => _selectedGender = '여성'),
                  ),
                ),
              ],
            ),
            const Spacer(),
            CheckboxListTile(
              value: _agreedToTerms,
              onChanged: (value) =>
                  setState(() => _agreedToTerms = value ?? false),
              title: const Text(
                '이용약관 및 개인정보 처리방침에 동의합니다',
                style: TextStyle(fontSize: 14),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      bottomButton: OnboardingButton(
        text: '시작하기',
        onPressed: () {
          // TODO: Complete onboarding and navigate to home
        },
        isEnabled: _isValid,
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : null,
            color: isSelected ? Theme.of(context).colorScheme.primary : null,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
