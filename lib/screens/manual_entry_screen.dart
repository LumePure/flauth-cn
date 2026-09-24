import 'package:flutter/material.dart';
import 'package:flauth/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/account_provider.dart';

bool isValidBase32(String input) {
  final cleaned = input.replaceAll(' ', '').toUpperCase();
  if (cleaned.isEmpty) return false;
  return RegExp(r'^[A-Z2-7]+=*$').hasMatch(cleaned);
}

class ManualEntryScreen extends StatefulWidget {
  const ManualEntryScreen({super.key});

  @override
  State<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends State<ManualEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _issuerController = TextEditingController();
  final _nameController = TextEditingController();
  final _secretController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _issuerController.dispose();
    _nameController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final issuer = _issuerController.text.trim();
    final name = _nameController.text.trim();
    final secret = _secretController.text.replaceAll(' ', '').toUpperCase();

    final success = await Provider.of<AccountProvider>(
      context,
      listen: false,
    ).addAccount(name, secret, issuer: issuer);

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    final l10n = AppLocalizations.of(context)!;
    final label = issuer.isNotEmpty ? issuer : name;
    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.addedAccount(label))));
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.accountAlreadyExists(label)),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addAccount)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _issuerController,
                decoration: InputDecoration(
                  labelText: l10n.issuerOptionalLabel,
                  hintText: l10n.issuerHint,
                  prefixIcon: const Icon(Icons.business),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.accountName,
                  hintText: l10n.accountNameHint,
                  prefixIcon: const Icon(Icons.person),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.accountNameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _secretController,
                decoration: InputDecoration(
                  labelText: l10n.secretKey,
                  hintText: l10n.secretKeyHint,
                  prefixIcon: const Icon(Icons.key),
                ),
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.characters,
                autocorrect: false,
                enableSuggestions: false,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.secretKeyRequired;
                  }
                  if (!isValidBase32(value)) {
                    return l10n.invalidSecretKey;
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.addAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
