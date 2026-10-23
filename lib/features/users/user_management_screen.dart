import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/theme/app_colors.dart';
import '../../core/extensions/context_x.dart';
import '../../core/localization/generated/app_localizations.dart';
import '../../core/utils/messages.dart';
import '../../core/widgets/cs_controls.dart';
import '../../core/widgets/cs_layout.dart';
import '../../data/models.dart';
import '../../state/account_controller.dart';
import '../../state/auth_controller.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    final account = context.read<AccountController>();
    Future<void>.microtask(account.loadUsers);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final account = context.watch<AccountController>();
    final me = context.watch<AuthController>().user?.id;
    return Scaffold(
      body: SafeArea(
        child: CenteredFrame(
          maxWidth: 860,
          child: Column(
            children: [
              ScreenHeader(title: s.userManagement),
              const SizedBox(height: 12),
              TextField(
                controller: _search,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(hintText: s.searchUsers, prefixIcon: const Icon(Icons.search)),
                onSubmitted: (value) => account.loadUsers(query: value),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final filter in [('all', s.allUsers), ('active', s.activeStatus), ('banned', s.bannedStatus), ('inactive', s.inactiveStatus)])
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: ChoiceChip(
                          label: Text(filter.$2),
                          selected: account.userStatus == filter.$1,
                          onSelected: (_) => account.loadUsers(status: filter.$1),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: account.loadingUsers && account.users.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : account.usersError != null
                        ? EmptyPane(message: messageFor(s, account.usersError!), onRetry: account.loadUsers)
                        : account.users.isEmpty
                            ? EmptyPane(message: s.noUsersFound)
                            : ListView.separated(
                                itemCount: account.users.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final user = account.users[index];
                                  return Card(
                                    child: ListTile(
                                      onTap: () => _open(user),
                                      leading: InitialsAvatar(name: user.fullName),
                                      title: Text(user.id == me ? '${user.fullName} · ${s.you}' : user.fullName),
                                      subtitle: Text(user.email),
                                      trailing: StatusChip(label: _status(s, user), tone: user.statusKey),
                                    ),
                                  );
                                },
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _status(S s, UserProfile user) {
    if (user.isBanned) return s.bannedStatus;
    if (!user.isActive) return s.inactiveStatus;
    return s.activeStatus;
  }

  Future<void> _open(UserProfile user) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _UserSheet(user: user),
    );
  }
}

class _UserSheet extends StatelessWidget {
  const _UserSheet({required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final me = context.watch<AuthController>().user?.id;
    final self = me == user.id;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 24 + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(user.fullName, style: context.text.titleLarge),
          const SizedBox(height: 4),
          Text(user.email, style: context.text.bodyMedium),
          Text(user.phoneE164, style: context.text.bodySmall),
          const SizedBox(height: 8),
          Text('${s.joined}: ${formatWhen(context, user.createdAt)}', style: context.text.bodySmall),
          const SizedBox(height: 16),
          Text(s.changeRole, style: context.text.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'user', label: Text(s.roleUser)),
              ButtonSegment(value: 'admin', label: Text(s.roleAdmin)),
            ],
            selected: {user.role},
            onSelectionChanged: self
                ? null
                : (value) async {
                    await _run(context, () => context.read<AccountController>().updateUser(user.id, role: value.first), s.roleUpdated);
                  },
          ),
          if (self) ...[
            const SizedBox(height: 8),
            Text(s.cannotChangeSelf, style: context.text.bodySmall),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (!user.isBanned)
                OutlinedButton(
                  onPressed: self ? null : () => _confirm(context, s.confirmBan, () => context.read<AccountController>().updateUser(user.id, isBanned: true), s.userBanned),
                  child: Text(s.banUser),
                ),
              if (user.isBanned)
                OutlinedButton(
                  onPressed: self ? null : () => _confirm(context, s.confirmUnban, () => context.read<AccountController>().updateUser(user.id, isBanned: false), s.userUnbanned),
                  child: Text(s.unbanUser),
                ),
              if (user.isActive && !user.isBanned)
                OutlinedButton(
                  onPressed: self ? null : () => _confirm(context, s.confirmDeactivate, () => context.read<AccountController>().updateUser(user.id, isActive: false), s.userDeactivated),
                  child: Text(s.deactivateUser),
                ),
              if (!user.isActive && !user.isBanned)
                OutlinedButton(
                  onPressed: self ? null : () => _confirm(context, s.confirmActivate, () => context.read<AccountController>().updateUser(user.id, isActive: true), s.userActivated),
                  child: Text(s.activateUser),
                ),
              TextButton(
                onPressed: self
                    ? null
                    : () => _confirm(context, s.confirmDelete, () => context.read<AccountController>().updateUser(user.id, delete: true), s.userDeleted),
                child: Text(s.deleteUser, style: const TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirm(BuildContext context, String message, Future<UserProfile> Function() action, String success) async {
    final ok = await confirmAction(context, title: context.s.confirm, message: message);
    if (!ok || !context.mounted) return;
    await _run(context, action, success);
  }

  Future<void> _run(BuildContext context, Future<UserProfile> Function() action, String success) async {
    try {
      await action();
      if (!context.mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(success), backgroundColor: AppColors.primary));
    } catch (error) {
      if (context.mounted) showAppMessage(context, messageFor(context.s, error), error: true);
    }
  }
}
