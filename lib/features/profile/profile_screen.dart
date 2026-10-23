import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/country_codes.dart';
import '../../core/extensions/context_x.dart';
import '../../core/utils/messages.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/cs_controls.dart';
import '../../core/widgets/cs_layout.dart';
import '../../state/auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _form = GlobalKey<FormState>();
  final _passwordForm = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();
  late CountryDial _country;
  bool _editing = false;
  bool _saving = false;
  bool _changing = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthController>().user;
    _name = TextEditingController(text: user?.fullName ?? '');
    _phone = TextEditingController(text: user?.phoneNational ?? '');
    _country = countryByDial(user?.countryCode ?? '+971');
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final user = context.watch<AuthController>().user;
    if (user == null) return const Scaffold(body: SizedBox.shrink());
    final validators = AppValidators(s);
    final status = user.isBanned ? s.bannedStatus : (user.isActive ? s.activeStatus : s.inactiveStatus);
    return Scaffold(
      body: SafeArea(
        child: CenteredFrame(
          maxWidth: 640,
          child: ListView(
            children: [
              ScreenHeader(
                title: s.profile,
                trailing: TextButton(
                  onPressed: () => setState(() => _editing = !_editing),
                  child: Text(_editing ? s.cancel : s.editProfile),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  InitialsAvatar(name: user.fullName, size: 64),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.fullName, style: context.text.titleLarge),
                        Text(user.isAdmin ? s.roleAdmin : s.roleUser, style: context.text.bodySmall),
                      ],
                    ),
                  ),
                  StatusChip(label: status, tone: user.statusKey),
                ],
              ),
              const SizedBox(height: 18),
              Text(s.personalInformation, style: context.text.titleMedium),
              const SizedBox(height: 10),
              Form(
                key: _form,
                child: Column(
                  children: [
                    CsTextField(controller: _name, label: s.fullName, validator: validators.name, enabled: _editing),
                    const SizedBox(height: 12),
                    InputDecorator(decoration: InputDecoration(labelText: s.email), child: Text(user.email)),
                    const SizedBox(height: 12),
                    PhoneField(
                      controller: _phone,
                      country: _country,
                      enabled: _editing,
                      onCountry: (value) => setState(() => _country = value),
                      validator: validators.phone,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text('${s.memberSince} ${formatWhen(context, user.createdAt)}', style: context.text.bodySmall),
              const SizedBox(height: 12),
              if (_editing) CsButton(label: s.saveChanges, loading: _saving, onPressed: _save),
              const SizedBox(height: 22),
              Text(s.securitySettings, style: context.text.titleMedium),
              const SizedBox(height: 10),
              Form(
                key: _passwordForm,
                child: Column(
                  children: [
                    PasswordField(controller: _current, label: s.currentPassword, validator: validators.password),
                    const SizedBox(height: 12),
                    PasswordField(controller: _next, label: s.newPassword, validator: validators.password),
                    const SizedBox(height: 12),
                    PasswordField(
                      controller: _confirm,
                      label: s.confirmNewPassword,
                      validator: (value) => validators.confirmPassword(value, _next.text),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CsButton(label: s.changePassword, loading: _changing, onPressed: _changePassword),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await context.read<AuthController>().updateProfile(fullName: _name.text, countryCode: _country.dial, phone: _phone.text);
      if (!mounted) return;
      setState(() => _editing = false);
      showAppMessage(context, context.s.profileUpdated);
    } catch (error) {
      if (mounted) showAppMessage(context, messageFor(context.s, error), error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _changePassword() async {
    if (!_passwordForm.currentState!.validate()) return;
    setState(() => _changing = true);
    try {
      await context.read<AuthController>().changePassword(currentPassword: _current.text, newPassword: _next.text);
      if (!mounted) return;
      _current.clear();
      _next.clear();
      _confirm.clear();
      showAppMessage(context, context.s.passwordChanged);
    } catch (error) {
      if (mounted) showAppMessage(context, messageFor(context.s, error), error: true);
    } finally {
      if (mounted) setState(() => _changing = false);
    }
  }
}
