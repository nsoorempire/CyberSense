import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/context_x.dart';
import '../../core/utils/messages.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/brand.dart';
import '../../core/widgets/cs_controls.dart';
import '../../core/widgets/cs_layout.dart';
import '../../state/auth_controller.dart';
import '../../state/settings_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _remember = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final saved = context.read<SettingsController>().rememberedEmail;
    if (saved != null) _email.text = saved;
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            const SizedBox(height: 8),
            const BrandLockup(markSize: 56),
            const SizedBox(height: 28),
            Text(s.login, style: context.text.headlineSmall),
            const SizedBox(height: 6),
            Text(s.loginSubtitle, style: context.text.bodyMedium?.copyWith(color: context.text.bodySmall?.color)),
            const SizedBox(height: 22),
            CsTextField(
              controller: _email,
              label: s.email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              validator: validators.email,
              prefix: const Icon(Icons.mail_outline),
            ),
            const SizedBox(height: 14),
            PasswordField(
              controller: _password,
              label: s.password,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              validator: validators.password,
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Checkbox(value: _remember, onChanged: (value) => setState(() => _remember = value ?? false)),
                Expanded(child: Text(s.rememberMe, style: context.text.bodyMedium)),
                TextButton(onPressed: () => context.push('/forgot-password'), child: Text(s.forgotPassword)),
              ],
            ),
            const SizedBox(height: 8),
            CsButton(label: s.loginButton, loading: _loading, onPressed: _submit),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(s.dontHaveAccount, style: context.text.bodyMedium),
                TextButton(onPressed: () => context.push('/signup'), child: Text(s.signUpHere)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await context.read<AuthController>().login(email: _email.text, password: _password.text, rememberMe: _remember);
      if (mounted) context.push('/otp');
    } catch (error) {
      if (mounted) showAppMessage(context, messageFor(context.s, error), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
