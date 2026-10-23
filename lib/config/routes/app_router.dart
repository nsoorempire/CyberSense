import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/activity/activity_screen.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/otp_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/auth/welcome_screen.dart';
import '../../features/dashboard/admin_dashboard_screen.dart';
import '../../features/dashboard/user_dashboard_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/sessions/sessions_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/shell/app_shell.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/users/user_management_screen.dart';
import '../../state/auth_controller.dart';
import '../../state/settings_controller.dart';

GoRouter createRouter(AuthController auth, SettingsController settings) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: Listenable.merge([auth, settings]),
    redirect: (context, state) {
      final loc = state.matchedLocation;
      if (!auth.ready) return loc == '/' ? null : '/';

      final authed = auth.isAuthenticated;
      final onboarding = settings.onboardingDone;
      const public = {'/onboarding', '/welcome', '/login', '/signup', '/otp', '/forgot-password', '/reset-password'};

      if (loc == '/') {
        if (!onboarding) return '/onboarding';
        if (!authed) return '/welcome';
        return auth.isAdmin ? '/admin/home' : '/app/home';
      }
      if (!onboarding && loc != '/onboarding') return '/onboarding';
      if (!authed && !public.contains(loc)) return '/welcome';
      if (loc == '/otp' && auth.pendingChallenge == null) return '/login';
      if (loc == '/reset-password' && auth.resetToken == null) return '/forgot-password';
      if (authed && (loc == '/welcome' || loc == '/login' || loc == '/signup' || loc == '/onboarding' || (loc == '/otp' && auth.pendingChallenge?.purpose != 'reset'))) {
        return auth.isAdmin ? '/admin/home' : '/app/home';
      }
      if (authed && auth.isAdmin && loc.startsWith('/app')) return '/admin/home';
      if (authed && !auth.isAdmin && loc.startsWith('/admin')) return '/app/home';
      return null;
    },
    routes: [
      GoRoute(path: '/', pageBuilder: (context, state) => _page(state, const SplashScreen())),
      GoRoute(path: '/onboarding', pageBuilder: (context, state) => _page(state, const OnboardingScreen())),
      GoRoute(path: '/welcome', pageBuilder: (context, state) => _page(state, const WelcomeScreen())),
      GoRoute(path: '/login', pageBuilder: (context, state) => _page(state, const LoginScreen())),
      GoRoute(path: '/signup', pageBuilder: (context, state) => _page(state, const SignupScreen())),
      GoRoute(path: '/otp', pageBuilder: (context, state) => _page(state, const OtpScreen())),
      GoRoute(path: '/forgot-password', pageBuilder: (context, state) => _page(state, const ForgotPasswordScreen())),
      GoRoute(path: '/reset-password', pageBuilder: (context, state) => _page(state, const ResetPasswordScreen())),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell, admin: false),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/app/home', builder: (_, __) => const UserDashboardScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/app/activity', builder: (_, __) => const ActivityScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/app/profile', builder: (_, __) => const ProfileScreen())]),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/settings',
                builder: (_, __) => const SettingsScreen(sessionsPath: '/app/settings/sessions', activityPath: null),
                routes: [GoRoute(path: 'sessions', builder: (_, __) => const SessionsScreen())],
              ),
            ],
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell, admin: true),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/home',
                builder: (_, __) => const AdminDashboardScreen(),
                routes: [GoRoute(path: 'activity', builder: (_, __) => const ActivityScreen())],
              ),
            ],
          ),
          StatefulShellBranch(routes: [GoRoute(path: '/admin/users', builder: (_, __) => const UserManagementScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/admin/profile', builder: (_, __) => const ProfileScreen())]),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/settings',
                builder: (_, __) => const SettingsScreen(sessionsPath: '/admin/settings/sessions', activityPath: '/admin/home/activity'),
                routes: [GoRoute(path: 'sessions', builder: (_, __) => const SessionsScreen())],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

Page<void> _page(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondary, child) {
      final slide = Tween<Offset>(begin: const Offset(0, 0.035), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      return FadeTransition(opacity: animation, child: SlideTransition(position: slide, child: child));
    },
  );
}
