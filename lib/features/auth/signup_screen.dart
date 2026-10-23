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

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  CountryDial _country = countries.first;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Text(s.createAccount, style: context.text.headlineSmall),
            const SizedBox(height: 6),
            Text(s.createAccountSubtitle, style: context.text.bodyMedium?.copyWith(color: context.text.bodySmall?.color)),
            const SizedBox(height: 22),
            CsTextField(controller: _name, label: s.fullName, textInputAction: TextInputAction.next, validator: validators.name, prefix: const Icon(Icons.person_outline)),
            const SizedBox(height: 14),
            CsTextField(
              controller: _email,
              label: s.email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: validators.email,
              prefix: const Icon(Icons.mail_outline),
            ),
            const SizedBox(height: 14),
            PhoneField(controller: _phone, country: _country, onCountry: (value) => setState(() => _country = value), validator: validators.phone),
            const SizedBox(height: 14),
            PasswordField(controller: _password, label: s.password, textInputAction: TextInputAction.next, validator: validators.password),
            const SizedBox(height: 8),
            Text(s.passwordRules, style: context.text.bodySmall),
            const SizedBox(height: 14),
            PasswordField(
              controller: _confirm,
              label: s.confirmPassword,
              textInputAction: TextInputAction.done,
              validator: (value) => validators.confirmPassword(value, _password.text),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 14),
            InfoBanner(message: s.whatsappOtpNote),
            const SizedBox(height: 18),
            CsButton(label: s.signUpButton, loading: _loading, onPressed: _submit),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(s.alreadyHaveAccount, style: context.text.bodyMedium),
                TextButton(onPressed: () => context.go('/login'), child: Text(s.signInHere)),
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
      await context.read<AuthController>().register(
            fullName: _name.text,
            email: _email.text,
            countryCode: _country.dial,
            phone: _phone.text,
            password: _password.text,
          );
      if (mounted) context.push('/otp');
    } catch (error) {
      if (mounted) showAppMessage(context, messageFor(context.s, error), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
