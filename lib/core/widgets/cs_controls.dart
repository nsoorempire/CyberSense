import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../constants/country_codes.dart';
import '../extensions/context_x.dart';

class CsButton extends StatelessWidget {
  const CsButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.filled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
          )
        : Text(label);
    final style = FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.45),
      disabledForegroundColor: Colors.white,
      minimumSize: const Size.fromHeight(54),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: context.text.labelLarge?.copyWith(color: Colors.white),
    );
    if (!filled) {
      return OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(54),
          side: const BorderSide(color: AppColors.primary, width: 1.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: context.text.labelLarge?.copyWith(color: AppColors.primary),
        ),
        child: loading
            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4))
            : Text(label, style: const TextStyle(color: AppColors.primary)),
      );
    }
    return FilledButton(onPressed: loading ? null : onPressed, style: style, child: child);
  }
}

class CsTextField extends StatelessWidget {
  const CsTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscure = false,
    this.suffix,
    this.prefix,
    this.autofillHints,
    this.onSubmitted,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscure;
  final Widget? suffix;
  final Widget? prefix;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscure,
      enabled: enabled,
      autofillHints: autofillHints,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(labelText: label, hintText: hint, suffixIcon: suffix, prefixIcon: prefix),
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.textInputAction,
    this.autofillHints,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return CsTextField(
      controller: widget.controller,
      label: widget.label,
      validator: widget.validator,
      obscure: _hidden,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      onSubmitted: widget.onSubmitted,
      suffix: IconButton(
        tooltip: _hidden ? s.showPassword : s.hidePassword,
        onPressed: () => setState(() => _hidden = !_hidden),
        icon: Icon(_hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined),
      ),
    );
  }
}

class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.controller,
    required this.country,
    required this.onCountry,
    this.validator,
    this.enabled = true,
  });

  final TextEditingController controller;
  final CountryDial country;
  final ValueChanged<CountryDial> onCountry;
  final String? Function(String?)? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 118,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: enabled ? () => _pick(context) : null,
            child: InputDecorator(
              decoration: InputDecoration(labelText: s.country),
              child: Text('${country.flag}  ${country.dial}', style: context.text.bodyLarge),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: CsTextField(
              controller: controller,
              label: s.phoneNumber,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              validator: validator,
              enabled: enabled,
              prefix: const Icon(Icons.phone_outlined),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pick(BuildContext context) async {
    final selected = await showModalBottomSheet<CountryDial>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => const _CountrySheet(),
    );
    if (selected != null) onCountry(selected);
  }
}

class _CountrySheet extends StatefulWidget {
  const _CountrySheet();

  @override
  State<_CountrySheet> createState() => _CountrySheetState();
}

class _CountrySheetState extends State<_CountrySheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final language = Localizations.localeOf(context).languageCode;
    final items = countries.where((item) {
      final q = _query.trim().toLowerCase();
      if (q.isEmpty) return true;
      return item.nameEn.toLowerCase().contains(q) || item.nameAr.contains(_query.trim()) || item.dial.contains(q) || item.iso.toLowerCase().contains(q);
    }).toList();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.62,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: TextField(
                decoration: InputDecoration(hintText: s.searchCountry, prefixIcon: const Icon(Icons.search)),
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    leading: Text(item.flag, style: const TextStyle(fontSize: 22)),
                    title: Text(item.name(language)),
                    trailing: Text(item.dial, style: context.text.titleSmall),
                    onTap: () => Navigator.pop(context, item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OtpBoxes extends StatelessWidget {
  const OtpBoxes({super.key, required this.controller, this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        maxLength: 6,
        autofocus: true,
        textAlign: TextAlign.center,
        style: context.text.headlineMedium?.copyWith(letterSpacing: 16),
        decoration: const InputDecoration(counterText: '', hintText: '••••••'),
        onChanged: (value) {
          final digits = value.replaceAll(RegExp(r'\D'), '');
          if (digits != value) {
            controller.value = TextEditingValue(text: digits, selection: TextSelection.collapsed(offset: digits.length));
          }
          onChanged?.call(digits);
        },
      ),
    );
  }
}

class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({super.key, required this.name, this.size = 48});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final parts = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    String glyph(String word) => word.isEmpty ? '' : String.fromCharCode(word.runes.first);
    final letters = parts.isEmpty
        ? '?'
        : parts.length == 1
            ? glyph(parts.first)
            : '${glyph(parts.first)}${glyph(parts.last)}';
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.isDark ? const Color(0xFF2A1240) : AppColors.primarySurface,
        shape: BoxShape.circle,
      ),
      child: Text(letters.toUpperCase(), style: context.text.titleMedium?.copyWith(color: context.isDark ? AppColors.iconActiveDark : AppColors.primary)),
    );
  }
}
