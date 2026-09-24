import 'package:flutter/material.dart';
import 'package:flauth/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import 'security_screen.dart';
import 'import_export_screen.dart';
import 'webdav_config_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'dev@liujiacai.net',
      query: 'subject=Flauth Feedback',
    );
    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch email');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = Provider.of<AuthProvider>(context);
    final locale = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          _SectionHeader(title: l10n.general),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(_languageLabel(l10n, locale.locale)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguagePicker(context, l10n, locale),
          ),

          const Divider(),

          _SectionHeader(title: l10n.security),
          ListTile(
            leading: const Icon(Icons.security_outlined),
            title: Text(l10n.pinProtection),
            subtitle: Text(auth.hasPin ? l10n.enabled : l10n.disabled),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SecurityScreen()),
              );
            },
          ),
          if (auth.hasPin)
            SwitchListTile(
              secondary: const Icon(Icons.fingerprint),
              title: Text(l10n.biometricUnlock),
              subtitle: Text(l10n.biometricSubtitle),
              value: auth.isBiometricEnabled,
              onChanged: (val) => auth.toggleBiometrics(val),
            ),
          if (auth.hasPin)
            SwitchListTile(
              secondary: const Icon(Icons.enhanced_encryption_outlined),
              title: Text(l10n.usePinForBackup),
              subtitle: Text(l10n.usePinForBackupSubtitle),
              value: auth.isUsePinForBackupEnabled,
              onChanged: (val) => auth.toggleUsePinForBackup(val),
            ),

          const Divider(),

          _SectionHeader(title: l10n.backupAndRestore),
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: Text(l10n.localFile),
            subtitle: Text(l10n.localStorageDesc),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ImportExportScreen(initialTab: 0),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud_outlined),
            title: Text(l10n.webdavCloud),
            subtitle: Text(l10n.webdavCloudDesc),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ImportExportScreen(initialTab: 1),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(l10n.webdavSettings),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const WebDavConfigScreen(),
                ),
              );
            },
          ),

          const Divider(),

          _SectionHeader(title: l10n.about),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              return ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(l10n.appTitle),
                subtitle: Text(
                  snapshot.hasData
                      ? l10n.version(
                          snapshot.data!.version,
                          snapshot.data!.buildNumber,
                        )
                      : l10n.loading,
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.appDescription),
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: Text(l10n.github),
            subtitle: Text(l10n.githubUrl),
            trailing: const Icon(Icons.open_in_new, size: 16),
            onTap: () => _launchUrl('https://github.com/jiacai2050/flauth'),
          ),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: Text(l10n.feedbackAndSupport),
            subtitle: const Text('dev@liujiacai.net'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _launchEmail,
          ),

          const SizedBox(height: 24),
          Center(
            child: Text(
              '© ${DateTime.now().year} Jiacai Liu',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _languageLabel(AppLocalizations l10n, Locale? locale) {
    if (locale == null) return l10n.languageSystem;
    return locale.languageCode == 'zh'
        ? l10n.languageChinese
        : l10n.languageEnglish;
  }

  void _showLanguagePicker(
    BuildContext context,
    AppLocalizations l10n,
    LocaleProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        Widget option(String title, Locale? value) {
          final isSelected =
              value?.languageCode == provider.locale?.languageCode;
          return ListTile(
            title: Text(title),
            trailing: isSelected ? const Icon(Icons.check) : null,
            onTap: () {
              Navigator.of(sheetContext).pop();
              provider.select(value);
            },
          );
        }

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              option(l10n.languageSystem, null),
              option(l10n.languageChinese, const Locale('zh')),
              option(l10n.languageEnglish, const Locale('en')),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}
