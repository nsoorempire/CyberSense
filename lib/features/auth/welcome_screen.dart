import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_x.dart';
import '../../core/widgets/brand.dart';
import '../../core/widgets/cs_controls.dart';
import '../../core/widgets/cs_layout.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Scaffold(
      body: BrandBackdrop(
        child: SafeArea(
          child: CenteredFrame(
            maxWidth: 460,
            child: Column(
              children: [
                const Spacer(),
                BrandLockup(markSize: 84, showTagline: true, tagline: s.appTagline),
                const Spacer(),
                Text(s.welcomeTitle, textAlign: TextAlign.center, style: context.text.headlineSmall),
                const SizedBox(height: 8),
                Text(s.welcomeSubtitle, textAlign: TextAlign.center, style: context.text.bodyMedium?.copyWith(color: context.text.bodySmall?.color)),
                const SizedBox(height: 28),
                CsButton(label: s.login, onPressed: () => context.push('/login')),
                const SizedBox(height: 12),
                CsButton(label: s.createAccount, filled: false, onPressed: () => context.push('/signup')),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
