import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flauth/l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../models/account.dart';
import '../providers/account_provider.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  // Prevents multiple concurrent scan attempts (e.g., rapid button taps
  // or build loops). Ensures only one scanner activity is active at a time.
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    // Auto-trigger scanning as soon as the screen is presented.
    // We use a post-frame callback to ensure the UI is fully rendered
    // before launching the native scanner Activity.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScan();
    });
  }

  Future<void> _startScan() async {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
    });

    final l10n = AppLocalizations.of(context)!;

    try {
      // Explicitly request camera permission before scanning
      final status = await Permission.camera.request();

      if (!mounted) return;

      if (status.isDenied || status.isPermanentlyDenied) {
        _showError(l10n.cameraPermissionRequired);
        if (status.isPermanentlyDenied) {
          // Optional: Open settings if permanently denied
          // openAppSettings();
        }
        return;
      }

      // Launch the platform-native scanner (ZXing on Android, AVFoundation on iOS).
      // This is more robust than embedding a scanner widget on some hardware.
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': l10n.cancel,
            'flash_on': l10n.flashOn,
            'flash_off': l10n.flashOff,
          },
        ),
      );

      if (!mounted) return;

      if (result.type == ResultType.Barcode) {
        final rawValue = result.rawContent;
        // Authenticator URIs must follow the otpauth:// scheme.
        if (rawValue.startsWith('otpauth://')) {
          await _processUri(rawValue);
        } else {
          _showError(l10n.invalidQrCode);
        }
      } else if (result.type == ResultType.Cancelled) {
        // If user presses the back button in the scanner, we exit this screen.
        Navigator.of(context).pop();
      } else if (result.type == ResultType.Error) {
        _showError(l10n.scanError(result.rawContent));
      }
    } catch (e) {
      _showError(l10n.failedToStartScanner(e.toString()));
    } finally {
      // Always release the lock, even on failure, to allow manual retries.
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  /// Parses the 'otpauth://' URI and persists the new account.
  Future<void> _processUri(String uriString) async {
    try {
      final Uri uri = Uri.parse(uriString);
      final account = Account.fromUri(uri);

      // Save account to secure storage.
      final success = await Provider.of<AccountProvider>(
        context,
        listen: false,
      ).addAccountObject(account);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.addedAccount(account.name))),
          );
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.accountAlreadyExists(account.name)),
              backgroundColor: Colors.orange,
            ),
          );
          Navigator.of(context).pop();
        }
      }
    } on FormatException catch (e) {
      final l10n = AppLocalizations.of(context)!;
      if (e.message == Account.invalidSchemeError) {
        _showError(l10n.invalidOtpauthScheme);
      } else if (e.message == Account.missingSecretError) {
        _showError(l10n.uriMissingSecret);
      } else {
        _showError(l10n.failedToAddAccount(e.message));
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      _showError(l10n.failedToAddAccount(e.toString()));
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.scanQrCode)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code, size: 80, color: Colors.grey),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isScanning ? null : _startScan,
              icon: const Icon(Icons.camera_alt),
              label: Text(l10n.startScanning),
            ),
          ],
        ),
      ),
    );
  }
}
