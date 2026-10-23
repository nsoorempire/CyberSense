import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/theme/app_colors.dart';
import '../../core/extensions/context_x.dart';
import '../../core/utils/messages.dart';
import '../../core/widgets/cs_layout.dart';
import '../../state/account_controller.dart';
import '../../state/auth_controller.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_load);
  }

  Future<void> _load() async {
    final account = context.read<AccountController>();
    await Future.wait([account.loadStats(), account.loadUsers(), account.loadActivity()]);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final account = context.watch<AccountController>();
    final name = context.watch<AuthController>().user?.fullName ?? '';
    final stats = account.stats;
    return Scaffold(
      body: SafeArea(
        child: CenteredFrame(
          maxWidth: 960,
          child: RefreshIndicator(
            onRefresh: _load,
            child: ListView(
              children: [
                ScreenHeader(title: s.welcomeBackUser(name), subtitle: s.adminSubtitle),
                const SizedBox(height: 18),
                if (account.statsError != null) EmptyPane(message: messageFor(s, account.statsError!), onRetry: _load),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth > 720 ? 4 : 2;
                    final items = [
                      (s.totalUsers, stats?.total, Icons.groups_outlined),
                      (s.activeUsers, stats?.active, Icons.verified_outlined),
                      (s.bannedUsers, stats?.banned, Icons.block),
                      (s.inactiveUsers, stats?.inactive, Icons.pause_circle_outline),
                    ];
                    return GridView.count(
                      crossAxisCount: columns,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: columns == 4 ? 1.45 : 1.5,
                      children: [
                        for (final item in items) _StatCard(label: item.$1, value: item.$2, icon: item.$3, loading: account.loadingStats && stats == null),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(child: Text(s.recentUsers, style: context.text.titleMedium)),
                    TextButton(onPressed: () => context.go('/admin/users'), child: Text(s.viewAll)),
                  ],
                ),
                ...account.users.take(4).map((user) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(user.fullName),
                      subtitle: Text(user.email),
                      trailing: Text(user.isAdmin ? s.roleAdmin : s.roleUser, style: context.text.labelMedium),
                    )),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text(s.loginActivity, style: context.text.titleMedium)),
                    TextButton(onPressed: () => context.push('/admin/home/activity'), child: Text(s.viewAll)),
                  ],
                ),
                if (account.activities.isEmpty) EmptyPane(message: s.noActivity),
                ...account.activities.take(3).map((item) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(item.userName ?? item.email),
                      subtitle: Text(item.deviceName.isEmpty ? s.unknownDevice : item.deviceName),
                      trailing: Icon(item.success ? Icons.check_circle_outline : Icons.error_outline, color: item.success ? AppColors.success : AppColors.error),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.icon, required this.loading});

  final String label;
  final int? value;
  final IconData icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: context.isDark ? AppColors.iconActiveDark : AppColors.primary),
            const Spacer(),
            if (loading)
              const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
            else
              Text('${value ?? 0}', style: context.text.headlineSmall),
            Text(label, style: context.text.bodySmall),
          ],
        ),
      ),
    );
  }
}
