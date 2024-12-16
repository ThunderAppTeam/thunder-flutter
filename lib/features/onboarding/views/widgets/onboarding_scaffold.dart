import 'package:flutter/material.dart';

class OnboardingScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget content;
  final Widget bottomButton;
  final bool showAppBar;

  const OnboardingScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.content,
    required this.bottomButton,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              backgroundColor: Colors.transparent,
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    content,
                    const Spacer(),
                  ],
                ),
              ),
              bottomButton,
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
