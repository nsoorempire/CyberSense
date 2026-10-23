import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/country_codes.dart';
import '../../core/extensions/context_x.dart';
import '../../core/utils/messages.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/cs_controls.dart';
import '../../core/widgets/cs_layout.dart';
import '../../state/auth_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _phone = TextEditingController();
  CountryDial _country = countries.first;
  bool _loading = false;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return AuthScaffold(
      child: Form(
        key: _form,
        child: ListView(
          children: [
            Text(s.forgotPasswordTitle, style: context.text.headlineSmall),
            const SizedBox(height: 8),
            Text(s.forgotPasswordDesc, style: context.text.bodyLarge),
            const SizedBox(height: 22),
            PhoneField(
              controller: _phone,
              country: _country,
              onCountry: (value) => setState(() => _country = value),
              validator: AppValidators(s).phone,
            ),
            const SizedBox(height: 18),
            CsButton(label: s.sendResetCode, loading: _loading, onPressed: _submit),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await context.read<AuthController>().forgotPassword(countryCode: _country.dial, phone: _phone.text);
      if (mounted) context.push('/otp');
    } catch (error) {
      if (mounted) showAppMessage(context, messageFor(context.s, error), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final validators = AppValidators(s);
    return AuthScaffold(
      child: Form(
        key: _form,
        child: ListView(
          children: [
            Text(s.createNewPassword, style: context.text.headlineSmall),
            const SizedBox(height: 8),
            Text(s.passwordRules, style: context.text.bodyMedium),
            const SizedBox(height: 22),
            PasswordField(controller: _password, label: s.newPassword, validator: validators.password, textInputAction: TextInputAction.next),
            const SizedBox(height: 14),
            PasswordField(
              controller: _confirm,
              label: s.confirmNewPassword,
              textInputAction: TextInputAction.done,
              validator: (value) => validators.confirmPassword(value, _password.text),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 18),
            CsButton(label: s.resetPassword, loading: _loading, onPressed: _submit),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await context.read<AuthController>().resetPassword(_password.text);
      if (!mounted) return;
      showAppMessage(context, context.s.passwordResetSuccess);
      context.go('/login');
    } catch (error) {
      if (mounted) showAppMessage(context, messageFor(context.s, error), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
