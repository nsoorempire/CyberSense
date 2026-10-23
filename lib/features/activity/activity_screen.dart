import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/theme/app_colors.dart';
import '../../core/extensions/context_x.dart';
import '../../core/network/api_exception.dart';
import '../../core/utils/messages.dart';
import '../../core/widgets/cs_layout.dart';
import '../../state/account_controller.dart';
import '../../state/auth_controller.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  void initState() {
    super.initState();
    final account = context.read<AccountController>();
    Future<void>.microtask(account.loadActivity);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final account = context.watch<AccountController>();
    final admin = context.watch<AuthController>().isAdmin;
    final canPop = context.canPop();
    return Scaffold(
      body: SafeArea(
        child: CenteredFrame(
          maxWidth: 760,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (canPop) const Align(alignment: AlignmentDirectional.centerStart, child: BackButton()),
              ScreenHeader(title: s.loginActivity, subtitle: admin ? s.adminActivityHint : s.activityHint),
              const SizedBox(height: 8),
              Expanded(
                child: account.loadingActivity && account.activities.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : account.activityError != null
                        ? EmptyPane(message: messageFor(s, account.activityError!), onRetry: account.loadActivity)
                        : RefreshIndicator(
                            onRefresh: account.loadActivity,
                            child: account.activities.isEmpty
                                ? ListView(children: [EmptyPane(message: s.noActivity)])
                                : ListView.separated(
                                    itemCount: account.activities.length,
                                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                                    itemBuilder: (context, index) {
                                      final item = account.activities[index];
                                      final reason = item.reason == null ? null : messageFor(s, ApiException(code: item.reason!));
                                      return Card(
                                        child: ListTile(
                                          leading: Icon(
                                            item.success ? Icons.check_circle_outline : Icons.error_outline,
                                            color: item.success ? AppColors.success : AppColors.error,
                                          ),
                                          title: Text(admin ? (item.userName ?? item.email) : (item.deviceName.isEmpty ? s.unknownDevice : item.deviceName)),
                                          subtitle: Text(
                                            [
                                              formatWhen(context, item.createdAt),
                                              if (item.ipAddress.isNotEmpty) item.ipAddress,
                                              if (admin && item.deviceName.isNotEmpty) item.deviceName,
                                              if (!item.success && reason != null) reason,
                                            ].join('\n'),
                                          ),
                                          isThreeLine: true,
                                          trailing: StatusChip(label: item.success ? s.loginSuccess : s.loginFailed, tone: item.success ? 'success' : 'failed'),
                                        ),
                                      );
                                    },
                                  ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
