import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_x.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell, required this.admin});

  final StatefulNavigationShell shell;
  final bool admin;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (index) => shell.goBranch(index, initialLocation: index == shell.currentIndex),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.space_dashboard_outlined), selectedIcon: const Icon(Icons.space_dashboard), label: s.dashboard),
          admin
              ? NavigationDestination(icon: const Icon(Icons.group_outlined), selectedIcon: const Icon(Icons.group), label: s.usersShort)
              : NavigationDestination(icon: const Icon(Icons.history), selectedIcon: const Icon(Icons.history), label: s.activity),
          NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: s.profile),
          NavigationDestination(icon: const Icon(Icons.settings_outlined), selectedIcon: const Icon(Icons.settings), label: s.settings),
        ],
      ),
    );
  }
}
