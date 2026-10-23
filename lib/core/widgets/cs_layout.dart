import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme/app_colors.dart';
import '../extensions/context_x.dart';

class CenteredFrame extends StatelessWidget {
  const CenteredFrame({super.key, required this.child, this.maxWidth = 520, this.padding});

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding ?? pagePadding(context), child: child),
      ),
    );
  }
}

EdgeInsets pagePadding(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  final horizontal = width >= 840 ? 28.0 : 20.0;
  return EdgeInsets.fromLTRB(horizontal, 8, horizontal, 28);
}

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.child, this.showBack = true});

  final Widget child;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (showBack)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8, top: 4),
                  child: BackButton(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/welcome');
                      }
                    },
                  ),
                ),
              ),
            Expanded(
              child: CenteredFrame(
                maxWidth: 480,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key, required this.title, this.subtitle, this.trailing});

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.text.headlineSmall),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(subtitle!, style: context.text.bodyMedium?.copyWith(color: context.text.bodySmall?.color)),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, required this.tone});

  final String label;
  final String tone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tone) {
      'banned' => (AppColors.errorLight, const Color(0xFF991B1B)),
      'inactive' => (AppColors.warningLight, const Color(0xFF92400E)),
      'success' => (AppColors.successLight, const Color(0xFF065F46)),
      'failed' => (AppColors.errorLight, const Color(0xFF991B1B)),
      _ => (context.isDark ? const Color(0xFF143528) : AppColors.successLight, const Color(0xFF065F46)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: context.isDark && tone != 'banned' && tone != 'failed' ? fg.withValues(alpha: 0.18) : bg, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: context.text.labelMedium?.copyWith(color: context.isDark ? Colors.white : fg)),
    );
  }
}

class EmptyPane extends StatelessWidget {
  const EmptyPane({super.key, required this.message, this.onRetry, this.retryLabel});

  final String message;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 36, color: context.text.bodySmall?.color),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center, style: context.text.bodyMedium),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: Text(retryLabel ?? context.s.retry)),
          ],
        ],
      ),
    );
  }
}

class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.isDark ? const Color(0xFF2A1240) : AppColors.primarySurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(message, style: context.text.bodySmall?.copyWith(color: context.isDark ? AppColors.iconActiveDark : AppColors.primaryDark)),
    );
  }
}

Future<bool> confirmAction(BuildContext context, {required String title, required String message, String? confirmLabel}) async {
  final s = context.s;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(s.cancel)),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel ?? s.confirm),
        ),
      ],
    ),
  );
  return result ?? false;
}

void showAppMessage(BuildContext context, String message, {bool error = false}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: error ? AppColors.error : AppColors.primary,
    ),
  );
}

String formatWhen(BuildContext context, DateTime time) {
  final local = time.toLocal();
  final date = MaterialLocalizations.of(context).formatMediumDate(local);
  final clock = MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(local));
  return '$date · $clock';
}
