import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flauth/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/account_provider.dart';
import '../services/webdav_service.dart';

class WebDavConfigScreen extends StatefulWidget {
  const WebDavConfigScreen({super.key});

  @override
  State<WebDavConfigScreen> createState() => _WebDavConfigScreenState();
}

class _WebDavConfigScreenState extends State<WebDavConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pathController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
    _urlController.addListener(_updatePreview);
    _pathController.addListener(_updatePreview);
  }

  void _updatePreview() {
    setState(() {});
  }

  Future<void> _loadConfig() async {
    final provider = Provider.of<AccountProvider>(context, listen: false);
    final config = await provider.getWebDavConfig();
    if (config != null && mounted) {
      _urlController.text = config['url'] ?? '';
      _usernameController.text = config['username'] ?? '';
      _passwordController.text = config['password'] ?? '';
      _pathController.text = config['path'] ?? '';
    }
  }

  Future<void> _testAndSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final url = _urlController.text.trim();
    final user = _usernameController.text.trim();
    final pass = _passwordController.text.trim();
    final config = {'url': url, 'path': _pathController.text.trim()};
    final paths = WebDavService.getNormalizedPaths(config);
    final normalizedPath = paths['remotePath']!;

    try {
      final basicAuth = 'Basic ${base64Encode(utf8.encode('$user:$pass'))}';
      final uri = Uri.parse(paths['baseUrl']!);

      // Use PROPFIND with Depth: 0 to check if the root
      // (or URL) exists/is accessible
      // This is a standard WebDAV check.
      final client = http.Client();
      final request = http.Request('PROPFIND', uri)
        ..headers['Authorization'] = basicAuth
        ..headers['Depth'] = '0';

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      client.close();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (mounted) {
          final provider = Provider.of<AccountProvider>(context, listen: false);
          await provider.saveWebDavConfig(url, user, pass, normalizedPath);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.connectionSuccessful),
            ),
          );
          Navigator.of(context).pop();
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(
                context,
              )!.serverRespondedWithStatus(response.statusCode),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.connectionFailed(e.toString()),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getFullPathPreview() {
    final config = {
      'url': _urlController.text.trim(),
      'path': _pathController.text.trim(),
    };
    if (config['url']!.isEmpty) {
      return AppLocalizations.of(context)!.pleaseEnterServerUrl;
    }

    final paths = WebDavService.getNormalizedPaths(config);
    return '${paths['baseUrl']}${paths['remotePath']}${WebDavService.fileName}';
  }

  @override
  void dispose() {
    _urlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _pathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.webdavConfiguration)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    labelText: l10n.serverUrl,
                    hintText: 'https://dav.example.com/',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? l10n.urlIsRequired : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: l10n.username,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? l10n.usernameIsRequired : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (v) =>
                      v == null || v.isEmpty ? l10n.passwordIsRequired : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pathController,
                  decoration: InputDecoration(
                    labelText: l10n.remotePath,
                    hintText: '/flauth_backups/',
                    border: const OutlineInputBorder(),
                    helperText: l10n.leaveEmptyForRoot,
                  ),
                ),
                const SizedBox(height: 16),
                // Path Preview
                if (_urlController.text.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.fullBackupPathPreview,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SelectableText(
                          _getFullPathPreview(),
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'monospace',
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _testAndSave,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.testConnectionAndSave),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
