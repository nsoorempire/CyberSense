import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/theme/app_colors.dart';
import '../../core/constants/app_config.dart';
import '../../core/extensions/context_x.dart';
import '../../core/widgets/cs_controls.dart';
import '../../core/widgets/cs_layout.dart';
import '../../state/auth_controller.dart';

class UserDashboardScreen extends StatelessWidget {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final user = context.watch<AuthController>().user;
    final cards = [
      (Icons.radar_outlined, s.threatAnalysis),
      (Icons.mark_email_unread_outlined, s.emailScanner),
      (Icons.link_outlined, s.urlChecker),
      (Icons.assessment_outlined, s.securityReports),
    ];
    return Scaffold(
      body: SafeArea(
        child: CenteredFrame(
          maxWidth: 960,
          child: ListView(
            children: [
              ScreenHeader(title: s.welcomeBackUser(user?.fullName ?? ''), subtitle: s.userSubtitle),
              const SizedBox(height: 18),
              if (AppConfig.useMock) ...[
                InfoBanner(message: s.mockModeBanner),
                const SizedBox(height: 14),
              ],
              if (user != null) _AccountCard(userName: user.fullName, email: user.email, phone: user.phoneE164, role: user.isAdmin ? s.roleAdmin : s.roleUser),
              const SizedBox(height: 22),
              Text(s.upcomingTools, style: context.text.titleMedium),
              const SizedBox(height: 6),
              Text(s.upcomingToolsBody, style: context.text.bodySmall),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 720 ? 4 : 2;
                  return GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: columns == 4 ? 1.15 : 1.05,
                    children: [
                      for (final card in cards)
                        _SoonCard(
                          icon: card.$1,
                          title: card.$2,
                          onTap: () => showAppMessage(context, s.featureComingSoon),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.userName, required this.email, required this.phone, required this.role});

  final String userName;
  final String email;
  final String phone;
  final String role;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            InitialsAvatar(name: userName, size: 54),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.accountOverview, style: context.text.labelMedium),
                  const SizedBox(height: 2),
                  Text(email, style: context.text.titleSmall),
                  Text(phone, style: context.text.bodySmall),
                ],
              ),
            ),
            StatusChip(label: role, tone: 'active'),
          ],
        ),
      ),
    );
  }
}

class _SoonCard extends StatelessWidget {
  const _SoonCard({required this.icon, required this.title, required this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: context.isDark ? AppColors.iconActiveDark : AppColors.primary),
              const Spacer(),
              Text(title, style: context.text.titleSmall),
              const SizedBox(height: 6),
              Text(context.s.comingSoon, style: context.text.labelMedium?.copyWith(color: AppColors.primary)),
            ],
          ),
        ),
      ),
    );
  }
}
