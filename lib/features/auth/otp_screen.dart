import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/context_x.dart';
import '../../core/network/api_exception.dart';
import '../../core/utils/messages.dart';
import '../../core/widgets/cs_controls.dart';
import '../../core/widgets/cs_layout.dart';
import '../../state/auth_controller.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _code = TextEditingController();
  Timer? _timer;
  int _seconds = 60;
  int _attempts = 5;
  bool _loading = false;
  bool _resending = false;

  @override
  void initState() {
    super.initState();
    final challenge = context.read<AuthController>().pendingChallenge;
    _seconds = challenge?.resendIn ?? 60;
    _attempts = challenge?.attemptsLeft ?? 5;
    _start();
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds <= 0) {
        timer.cancel();
      } else if (mounted) {
        setState(() => _seconds -= 1);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final challenge = context.watch<AuthController>().pendingChallenge;
    if (challenge == null) {
      return const Scaffold(body: SizedBox.shrink());
    }
    return AuthScaffold(
      child: ListView(
        children: [
          Text(s.otpVerification, style: context.text.headlineSmall),
          const SizedBox(height: 8),
          Text(s.otpSentToNumber(challenge.maskedPhone), style: context.text.bodyLarge),
          const SizedBox(height: 6),
          Text(s.enterOtp, style: context.text.bodySmall),
          const SizedBox(height: 22),
          OtpBoxes(controller: _code),
          const SizedBox(height: 8),
          Text(s.attemptsLeft(_attempts), style: context.text.bodySmall),
          if (challenge.devCode != null) ...[
            const SizedBox(height: 14),
            InfoBanner(message: s.devOtpHint(challenge.devCode!)),
          ],
          const SizedBox(height: 22),
          CsButton(label: s.verifyOtp, loading: _loading, onPressed: _verify),
          const SizedBox(height: 12),
          Center(
            child: _seconds > 0
                ? Text(s.resendOtpIn(_seconds), style: context.text.bodyMedium)
                : TextButton(onPressed: _resending ? null : _resend, child: Text(_resending ? s.loading : s.resendOtp)),
          ),
        ],
      ),
    );
  }

  Future<void> _verify() async {
    if (_code.text.trim().length != 6) {
      showAppMessage(context, context.s.validationOtp, error: true);
      return;
    }
    setState(() => _loading = true);
    try {
      final auth = context.read<AuthController>();
      final purpose = auth.pendingChallenge?.purpose;
      await auth.verifyOtp(_code.text.trim());
      if (!mounted) return;
      if (purpose == 'reset') context.go('/reset-password');
    } catch (error) {
      if (!mounted) return;
      if (error is ApiException && error.attemptsLeft != null) {
        setState(() => _attempts = error.attemptsLeft!);
      }
      showAppMessage(context, messageFor(context.s, error), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resend() async {
    setState(() => _resending = true);
    try {
      final next = await context.read<AuthController>().resend();
      if (!mounted) return;
      setState(() {
        _seconds = next.resendIn;
        _attempts = next.attemptsLeft;
        _code.clear();
      });
      _start();
      showAppMessage(context, context.s.codeResent);
    } catch (error) {
      if (mounted) showAppMessage(context, messageFor(context.s, error), error: true);
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }
}
