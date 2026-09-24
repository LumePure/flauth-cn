import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flauth/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../providers/account_provider.dart';
import '../providers/auth_provider.dart';
import '../services/backup_security_service.dart';
import '../services/webdav_service.dart';
import 'webdav_config_screen.dart';

class ExportData {
  final String content;
  final String extension;

  ExportData(this.content, this.extension);
}

class ImportExportScreen extends StatefulWidget {
  final int initialTab;
  const ImportExportScreen({super.key, this.initialTab = 0});

  @override
  State<ImportExportScreen> createState() => _ImportExportScreenState();
}

class _ImportExportScreenState extends State<ImportExportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _isLoading = false;
  String? _lastCloudBackupTime;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, 1),
    );
    _tabController.addListener(() {
      if (_tabController.index == 1 && _lastCloudBackupTime == null) {
        _fetchLastCloudBackupTime();
      }
    });

    // Auto fetch if we start on the second tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_tabController.index == 1) _fetchLastCloudBackupTime();
    });
  }

  Future<void> _fetchLastCloudBackupTime() async {
    try {
      final config = await _getWebDavConfig();
      if (config == null) return;

      final lastModified = await WebDavService.fetchLastModified(config);
      if (lastModified != null) {
        try {
          final dateTime = HttpDate.parse(lastModified).toLocal();
          setState(() {
            _lastCloudBackupTime = DateFormat.yMMMd().add_Hms().format(
              dateTime,
            );
          });
        } catch (e) {
          debugPrint('Failed to parse last-modified date: $e');
          setState(() {
            _lastCloudBackupTime = lastModified;
          });
        }
      }
    } catch (e) {
      debugPrint('Failed to fetch backup time: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  // --- Helper Dialogs ---

  Future<String?> _showSetPasswordDialog() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _SetPasswordDialog(),
    );
  }

  Future<String?> _showEnterPasswordDialog() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _EnterPasswordDialog(),
    );
  }

  // --- Unified Security Logic ---

  Future<ExportData?> _prepareExportContent() async {
    final accountProvider = Provider.of<AccountProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final rawText = accountProvider.exportAccountsToText();

    if (rawText.isEmpty) {
      _showSnackBar(AppLocalizations.of(context)!.noAccountsToExport);
      return null;
    }

    String? password;
    bool usingAppPin = false;

    if (authProvider.isUsePinForBackupEnabled && authProvider.hasPin) {
      password = await authProvider.getBackupPassword();
      usingAppPin = true;
    } else {
      // Ask for encryption
      password = await _showSetPasswordDialog();
    }

    if (!mounted) return null;
    if (password == null) {
      // User cancelled
      return null;
    }

    String finalContent = rawText;
    String extension = 'flauth';

    if (password.isNotEmpty) {
      // Encrypt
      try {
        finalContent = BackupSecurityService.encrypt(rawText, password);
        if (usingAppPin) {
          _showSnackBar(AppLocalizations.of(context)!.encryptedWithAppPin);
        }
      } catch (e) {
        _showSnackBar(
          AppLocalizations.of(context)!.encryptionFailed(e.toString()),
          isError: true,
        );
        return null;
      }
    }
    return ExportData(finalContent, extension);
  }

  Future<String?> _processImportContent(String content) async {
    // Check encryption
    if (BackupSecurityService.isEncrypted(content)) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Try with App PIN first if enabled
      if (authProvider.isUsePinForBackupEnabled && authProvider.hasPin) {
        final pin = await authProvider.getBackupPassword();
        if (pin != null) {
          try {
            return BackupSecurityService.decrypt(content, pin);
          } catch (_) {
            // Decryption with PIN failed, maybe it was a custom password?
            // Fall through to manual password dialog
          }
        }
      }

      if (!mounted) return null;
      final password = await _showEnterPasswordDialog();
      if (!mounted) return null;
      if (password == null) {
        // Cancelled
        return null;
      }
      final l10n = AppLocalizations.of(context)!;
      try {
        return BackupSecurityService.decrypt(content, password);
      } on BackupPasswordException {
        _showSnackBar(l10n.decryptFailedInvalidPassword, isError: true);
        return null;
      } on FormatException {
        _showSnackBar(l10n.invalidBackupFormat, isError: true);
        return null;
      } catch (e) {
        _showSnackBar(l10n.decryptionFailed(e.toString()), isError: true);
        return null;
      }
    }
    return content;
  }

  // --- Local File Handlers ---

  Future<void> _handleLocalExport() async {
    setState(() => _isLoading = true);

    try {
      final exportData = await _prepareExportContent();
      if (exportData == null) return;

      final now = DateTime.now();
      final fileName =
          'otpauth-${DateFormat('yyyyMMdd-HHmmss').format(now)}'
          '.${exportData.extension}';

      if (Platform.isAndroid) {
        // Android: Use System "Save As" dialog via SAF
        // (Storage Access Framework)
        // 1. Write to temp file first
        final directory = await getTemporaryDirectory();
        final tempFile = File('${directory.path}/$fileName');
        await tempFile.writeAsString(exportData.content);

        // 2. Hand over to system dialog
        final params = SaveFileDialogParams(sourceFilePath: tempFile.path);
        final finalPath = await FlutterFileDialog.saveFile(params: params);

        if (finalPath != null) {
          _showSnackBar(AppLocalizations.of(context)!.backupSavedSuccessfully);
        }
      } else if (Platform.isIOS) {
        // iOS: Save to Documents
        final directory = await getApplicationDocumentsDirectory();
        final outputPath = '${directory.path}/$fileName';
        final file = File(outputPath);
        await file.writeAsString(exportData.content);

        _showSnackBar(AppLocalizations.of(context)!.savedToFiles);
      } else {
        // Desktop: Use Save Dialog
        final outputPath = await FilePicker.platform.saveFile(
          dialogTitle: AppLocalizations.of(context)!.saveBackupFile,
          fileName: fileName,
          type: FileType.custom,
          allowedExtensions: [exportData.extension],
        );

        if (outputPath != null) {
          final file = File(outputPath);
          await file.writeAsString(exportData.content);
          _showSnackBar(AppLocalizations.of(context)!.savedTo(outputPath));
        }
      }
    } catch (e) {
      debugPrint('Export error: $e');
      _showSnackBar(
        AppLocalizations.of(context)!.exportFailed(e.toString()),
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLocalImport() async {
    setState(() => _isLoading = true);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['flauth'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        String content = await file.readAsString();

        final decryptedContent = await _processImportContent(content);
        if (decryptedContent == null) return;

        if (!mounted) return;
        final provider = Provider.of<AccountProvider>(context, listen: false);
        final count = await provider.importAccountsFromText(decryptedContent);

        if (count > 0) {
          _showSnackBar(AppLocalizations.of(context)!.importedAccounts(count));
        } else {
          _showSnackBar(
            AppLocalizations.of(context)!.noNewAccountsAdded,
            backgroundColor: Colors.orange,
          );
        }
      }
    } catch (e) {
      debugPrint('Import error: $e');
      _showSnackBar(
        AppLocalizations.of(context)!.importFailed(e.toString()),
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // WebDAV Handlers

  Future<Map<String, String>?> _getWebDavConfig() async {
    final provider = Provider.of<AccountProvider>(context, listen: false);
    final config = await provider.getWebDavConfig();
    if (config == null || (config['url']?.isEmpty ?? true)) {
      _showSnackBar(AppLocalizations.of(context)!.pleaseConfigureWebdav);
      _openWebDavConfig();
      return null;
    }
    return config;
  }

  void _openWebDavConfig() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const WebDavConfigScreen()));
  }

  Future<void> _handleWebDavUpload() async {
    setState(() => _isLoading = true);

    try {
      final config = await _getWebDavConfig();
      if (!mounted || config == null) return;

      final exportData = await _prepareExportContent();
      if (exportData == null) return;

      final response = await WebDavService.upload(config, exportData.content);

      if (!mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _showSnackBar(AppLocalizations.of(context)!.uploadedSuccessfully);
        final accountProvider = Provider.of<AccountProvider>(
          context,
          listen: false,
        );
        accountProvider.updateLastSyncTime();
        _fetchLastCloudBackupTime(); // Refresh cloud time
      } else {
        throw Exception('Status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      _showSnackBar(
        AppLocalizations.of(context)!.uploadFailed(e.toString()),
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleWebDavDownload() async {
    setState(() => _isLoading = true);

    try {
      final config = await _getWebDavConfig();
      if (!mounted || config == null) return;

      final response = await WebDavService.download(config);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final content = response.body;
        final decryptedContent = await _processImportContent(content);
        if (!mounted || decryptedContent == null) return;

        final provider = Provider.of<AccountProvider>(context, listen: false);
        final count = await provider.importAccountsFromText(decryptedContent);

        provider.updateLastSyncTime();
        if (count > 0) {
          _showSnackBar(AppLocalizations.of(context)!.syncedAccounts(count));
        } else {
          _showSnackBar(
            AppLocalizations.of(context)!.alreadyUpToDate,
            backgroundColor: Colors.orange,
          );
        }
      } else {
        throw Exception('Status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      _showSnackBar(
        AppLocalizations.of(context)!.downloadFailed(e.toString()),
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(
    String message, {
    bool isError = false,
    Color? backgroundColor,
  }) {
    if (!mounted) return;

    Color? bg = backgroundColor;
    if (bg == null && isError) {
      bg = Colors.red;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: bg));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.backupAndRestore),

        bottom: TabBar(
          controller: _tabController,

          tabs: [
            Tab(text: l10n.localFile, icon: const Icon(Icons.folder)),

            Tab(text: l10n.webdavCloud, icon: const Icon(Icons.cloud)),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openWebDavConfig,
            tooltip: l10n.webdavSettings,
          ),
        ],
      ),

      body: TabBarView(
        controller: _tabController,

        children: [
          // Local Tab
          _buildActionView(
            icon: Icons.sd_storage,
            title: l10n.localStorage,
            desc: l10n.localStorageDesc,
            btn1Text: l10n.exportToFile,
            btn1Icon: Icons.upload_file,
            btn1Action: _handleLocalExport,
            btn2Text: l10n.importFromFile,
            btn2Icon: Icons.drive_folder_upload,
            btn2Action: _handleLocalImport,
          ),

          // WebDAV Tab
          Selector<AccountProvider, DateTime?>(
            selector: (_, p) => p.lastWebDavSyncTime,
            builder: (context, lastSync, _) => _buildActionView(
              icon: Icons.cloud_sync,
              title: l10n.webdavCloud,
              desc: l10n.webdavCloudDesc,
              btn1Text: l10n.uploadToCloud,
              btn1Icon: Icons.cloud_upload,
              btn1Action: _handleWebDavUpload,
              btn2Text: l10n.restoreFromCloud,
              btn2Icon: Icons.cloud_download,
              btn2Action: _handleWebDavDownload,
              extra: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    if (_lastCloudBackupTime != null)
                      _buildTimeBadge(
                        context,
                        Icons.cloud_done_outlined,
                        l10n.cloud,
                        _lastCloudBackupTime!,
                      ),
                    if (lastSync != null)
                      _buildTimeBadge(
                        context,
                        Icons.sync_alt_outlined,
                        l10n.synced,
                        DateFormat.yMMMd().add_Hms().format(lastSync),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBadge(
    BuildContext context,
    IconData icon,
    String label,
    String time,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            '$label: $time',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionView({
    required IconData icon,
    required String title,
    required String desc,
    required String btn1Text,
    required IconData btn1Icon,
    required VoidCallback btn1Action,
    required String btn2Text,
    required IconData btn2Icon,
    required VoidCallback btn2Action,
    Widget? extra,
  }) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(icon, size: 80, color: Colors.blueGrey),
            const SizedBox(height: 32),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            ?extra,
            const SizedBox(height: 48),

            FilledButton.icon(
              onPressed: btn1Action,
              icon: Icon(btn1Icon),
              label: Text(btn1Text),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: btn2Action,
              icon: Icon(btn2Icon),
              label: Text(btn2Text),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SetPasswordDialog extends StatefulWidget {
  const _SetPasswordDialog();

  @override
  State<_SetPasswordDialog> createState() => _SetPasswordDialogState();
}

class _SetPasswordDialogState extends State<_SetPasswordDialog> {
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.encryptBackup),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.encryptBackupDesc,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passCtrl,
              decoration: InputDecoration(
                labelText: l10n.password,
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (val) => (val == null || val.length < 6)
                  ? l10n.minSixCharacters
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmCtrl,
              decoration: InputDecoration(
                labelText: l10n.confirmPassword,
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (val) =>
                  val != _passCtrl.text ? l10n.passwordsDoNotMatch : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, ''),
          child: Text(l10n.skipPlainText),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, _passCtrl.text.trim());
            }
          },
          child: Text(l10n.encrypt),
        ),
      ],
    );
  }
}

class _EnterPasswordDialog extends StatefulWidget {
  const _EnterPasswordDialog();

  @override
  State<_EnterPasswordDialog> createState() => _EnterPasswordDialogState();
}

class _EnterPasswordDialogState extends State<_EnterPasswordDialog> {
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.decryptBackup),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.fileIsEncrypted),
          const SizedBox(height: 16),
          TextField(
            controller: _passCtrl,
            decoration: InputDecoration(
              labelText: l10n.password,
              border: const OutlineInputBorder(),
            ),
            obscureText: true,
            autofocus: true,
            onSubmitted: (_) => Navigator.pop(context, _passCtrl.text),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _passCtrl.text),
          child: Text(l10n.unlock),
        ),
      ],
    );
  }
}
