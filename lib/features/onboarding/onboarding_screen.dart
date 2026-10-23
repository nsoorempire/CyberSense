import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/theme/app_colors.dart';
import '../../core/extensions/context_x.dart';
import '../../core/widgets/cs_controls.dart';
import '../../core/widgets/cs_layout.dart';
import '../../state/settings_controller.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final pages = [
      (Icons.shield_outlined, s.onboardingTitle1, s.onboardingDesc1),
      (Icons.verified_user_outlined, s.onboardingTitle2, s.onboardingDesc2),
      (Icons.layers_outlined, s.onboardingTitle3, s.onboardingDesc3),
    ];
    final last = _index == pages.length - 1;
    return Scaffold(
      body: SafeArea(
        child: CenteredFrame(
          maxWidth: 520,
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: last
                    ? const SizedBox(height: 48)
                    : TextButton(onPressed: _finish, child: Text(s.skip)),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: pages.length,
                  onPageChanged: (value) => setState(() => _index = value),
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 148,
                          height: 148,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.isDark ? const Color(0xFF2A1240) : AppColors.primarySurface,
                          ),
                          child: Icon(page.$1, size: 64, color: context.isDark ? AppColors.iconActiveDark : AppColors.primary),
                        ),
                        const SizedBox(height: 36),
                        Text(page.$2, textAlign: TextAlign.center, style: context.text.headlineSmall),
                        const SizedBox(height: 12),
                        Text(page.$3, textAlign: TextAlign.center, style: context.text.bodyLarge?.copyWith(color: context.text.bodySmall?.color)),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (index) {
                  final active = index == _index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsetsDirectional.only(end: 6),
                    width: active ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : AppColors.primary.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 22),
              CsButton(label: last ? s.getStarted : s.next, onPressed: last ? _finish : _next),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _next() {
    _controller.nextPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOutCubic);
  }

  Future<void> _finish() async {
    await context.read<SettingsController>().completeOnboarding();
    if (mounted) context.go('/welcome');
  }
}
