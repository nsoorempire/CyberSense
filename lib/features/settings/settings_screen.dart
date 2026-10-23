import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/theme/app_colors.dart';
import '../../core/constants/app_config.dart';
import '../../core/extensions/context_x.dart';
import '../../core/widgets/cs_layout.dart';
import '../../state/auth_controller.dart';
import '../../state/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.sessionsPath, required this.activityPath});

  final String sessionsPath;
  final String? activityPath;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final settings = context.watch<SettingsController>();
    final locale = settings.resolvedLocale();
    return Scaffold(
      body: SafeArea(
        child: CenteredFrame(
          maxWidth: 680,
          child: ListView(
            children: [
              ScreenHeader(title: s.settings, subtitle: s.preferences),
              const SizedBox(height: 16),
              Text(s.selectLanguage, style: context.text.titleMedium),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: 'en', label: Text(s.english)),
                  ButtonSegment(value: 'ar', label: Text(s.arabic)),
                ],
                selected: {locale.languageCode},
                onSelectionChanged: (value) => settings.setLocale(Locale(value.first)),
              ),
              const SizedBox(height: 20),
              Text(s.selectTheme, style: context.text.titleMedium),
              const SizedBox(height: 8),
              SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(value: ThemeMode.light, label: Text(s.lightMode)),
                  ButtonSegment(value: ThemeMode.dark, label: Text(s.darkMode)),
                  ButtonSegment(value: ThemeMode.system, label: Text(s.systemMode)),
                ],
                selected: {settings.themeMode},
                onSelectionChanged: (value) => settings.setTheme(value.first),
              ),
              const SizedBox(height: 20),
              Text(s.accountSettings, style: context.text.titleMedium),
              const SizedBox(height: 8),
              _Tile(icon: Icons.devices_outlined, title: s.sessionManagement, onTap: () => context.push(sessionsPath)),
              if (activityPath != null) _Tile(icon: Icons.history, title: s.loginActivity, onTap: () => context.push(activityPath!)),
              _Tile(icon: Icons.privacy_tip_outlined, title: s.privacyPolicy, onTap: () => _info(context, s.privacyPolicy, s.privacyBody)),
              _Tile(icon: Icons.article_outlined, title: s.termsOfService, onTap: () => _info(context, s.termsOfService, s.termsBody)),
              _Tile(icon: Icons.info_outline, title: s.about, onTap: () => _info(context, s.about, '${s.aboutBody}\n\n${s.version} ${AppConfig.appVersion}')),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  final ok = await confirmAction(context, title: s.logout, message: s.logoutConfirm, confirmLabel: s.logout);
                  if (!ok || !context.mounted) return;
                  await context.read<AuthController>().logout();
                },
                icon: const Icon(Icons.logout),
                label: Text(s.logout),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  minimumSize: const Size.fromHeight(52),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _info(BuildContext context, String title, String body) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(body)),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(context.s.ok))],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.title, required this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: context.isDark ? AppColors.iconActiveDark : AppColors.primary),
        title: Text(title),
        trailing: Icon(Directionality.of(context) == TextDirection.rtl ? Icons.chevron_left : Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
