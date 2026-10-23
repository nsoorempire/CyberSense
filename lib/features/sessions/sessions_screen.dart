import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/theme/app_colors.dart';
import '../../core/extensions/context_x.dart';
import '../../core/utils/messages.dart';
import '../../core/widgets/cs_controls.dart';
import '../../core/widgets/cs_layout.dart';
import '../../state/account_controller.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  @override
  void initState() {
    super.initState();
    final account = context.read<AccountController>();
    Future<void>.microtask(account.loadSessions);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final account = context.watch<AccountController>();
    return Scaffold(
      appBar: AppBar(title: Text(s.sessionManagement)),
      body: SafeArea(
        child: CenteredFrame(
          maxWidth: 720,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.sessionsHint, style: context.text.bodyMedium),
              const SizedBox(height: 12),
              Expanded(
                child: account.loadingSessions && account.sessions.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : account.sessionsError != null
                        ? EmptyPane(message: messageFor(s, account.sessionsError!), onRetry: account.loadSessions)
                        : account.sessions.isEmpty
                            ? EmptyPane(message: s.noSessions)
                            : ListView.separated(
                                itemCount: account.sessions.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final session = account.sessions[index];
                                  return Card(
                                    child: ListTile(
                                      leading: Icon(Icons.devices_outlined, color: context.isDark ? AppColors.iconActiveDark : AppColors.primary),
                                      title: Text(session.deviceName.isEmpty ? s.unknownDevice : session.deviceName),
                                      subtitle: Text('${s.started}: ${formatWhen(context, session.createdAt)}\n${s.lastActive}: ${formatWhen(context, session.lastUsedAt)}'),
                                      isThreeLine: true,
                                      trailing: session.current
                                          ? StatusChip(label: s.currentSession, tone: 'active')
                                          : IconButton(
                                              tooltip: s.endSession,
                                              onPressed: () => _end(session.id),
                                              icon: const Icon(Icons.close),
                                            ),
                                    ),
                                  );
                                },
                              ),
              ),
              const SizedBox(height: 12),
              CsButton(
                label: s.endAllSessions,
                onPressed: account.sessions.isEmpty
                    ? null
                    : () async {
                        final ok = await confirmAction(context, title: s.endAllSessions, message: s.confirmEndAllSessions);
                        if (!ok || !context.mounted) return;
                        try {
                          await context.read<AccountController>().revokeAll();
                        } catch (error) {
                          if (context.mounted) showAppMessage(context, messageFor(context.s, error), error: true);
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _end(String id) async {
    final s = context.s;
    final ok = await confirmAction(context, title: s.endSession, message: s.confirmEndSession);
    if (!ok || !mounted) return;
    try {
      final loggedOut = await context.read<AccountController>().revokeSession(id);
      if (!loggedOut && mounted) showAppMessage(context, s.sessionEnded);
    } catch (error) {
      if (mounted) showAppMessage(context, messageFor(context.s, error), error: true);
    }
  }
}
