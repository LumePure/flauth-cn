// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flauth';

  @override
  String get scan => 'Scan';

  @override
  String get importExport => 'Import / Export';

  @override
  String get about => 'About';

  @override
  String get noAccountsYet => 'No accounts yet';

  @override
  String get tapToScanQr => 'Tap the button below to scan a QR code';

  @override
  String get protectYourAccounts => 'Protect your accounts';

  @override
  String get protectYourAccountsDesc =>
      'It is highly recommended to set up a PIN to secure your 2FA tokens. Would you like to do it now?';

  @override
  String get later => 'Later';

  @override
  String get setupNow => 'Setup Now';

  @override
  String get security => 'Security';

  @override
  String get pinProtection => 'PIN Protection';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get changePin => 'Change PIN';

  @override
  String get biometricUnlock => 'Biometric Unlock';

  @override
  String get biometricSubtitle => 'Use FaceID / Fingerprint';

  @override
  String get biometricReason => 'Please authenticate to access Flauth';

  @override
  String get usePinForBackup => 'Use PIN for Backup';

  @override
  String get usePinForBackupSubtitle =>
      'Automatically use your App PIN to encrypt/decrypt backups';

  @override
  String get setNewPin => 'Set New PIN';

  @override
  String get confirmPin => 'Confirm PIN';

  @override
  String get enterSixDigitPin => 'Enter 6-digit PIN';

  @override
  String get reEnterToConfirm => 'Re-enter to confirm';

  @override
  String get pinSetSuccessfully => 'PIN Set Successfully';

  @override
  String get pinsDoNotMatch => 'PINs do not match. Try again.';

  @override
  String get enterPin => 'Enter PIN';

  @override
  String get incorrectPin => 'Incorrect PIN';

  @override
  String lockedForSeconds(int seconds) {
    return 'Locked for ${seconds}s';
  }

  @override
  String attemptsRemaining(int count) {
    return '$count attempts remaining';
  }

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get startScanning => 'Start Scanning';

  @override
  String get cancel => 'Cancel';

  @override
  String get flashOn => 'Flash On';

  @override
  String get flashOff => 'Flash Off';

  @override
  String get cameraPermissionRequired =>
      'Camera permission is required to scan QR codes';

  @override
  String get invalidQrCode => 'Invalid QR Code: Not an authenticator URI';

  @override
  String scanError(String error) {
    return 'Scan error: $error';
  }

  @override
  String failedToStartScanner(String error) {
    return 'Failed to start scanner: $error';
  }

  @override
  String addedAccount(String name) {
    return 'Added account: $name';
  }

  @override
  String accountAlreadyExists(String name) {
    return 'Account already exists: $name';
  }

  @override
  String failedToAddAccount(String error) {
    return 'Failed to add account: $error';
  }

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountConfirm =>
      'Are you sure you want to delete this account? This cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String accountDeleted(String name) {
    return '$name deleted';
  }

  @override
  String get codeRevealedAndCopied => 'Code revealed and copied to clipboard';

  @override
  String get backupAndRestore => 'Backup & Restore';

  @override
  String get localFile => 'Local File';

  @override
  String get webdavCloud => 'WebDAV Cloud';

  @override
  String get webdavSettings => 'WebDAV Settings';

  @override
  String get localStorage => 'Local Storage';

  @override
  String get localStorageDesc =>
      'Save backups to your device or import from local files.';

  @override
  String get exportToFile => 'Export to File';

  @override
  String get importFromFile => 'Import from File';

  @override
  String get webdavCloudDesc =>
      'Sync backups with your private cloud (Nextcloud, InfiniCloud etc).';

  @override
  String get uploadToCloud => 'Upload to Cloud';

  @override
  String get restoreFromCloud => 'Restore from Cloud';

  @override
  String get cloud => 'Cloud';

  @override
  String get synced => 'Synced';

  @override
  String get noAccountsToExport => 'No accounts to export';

  @override
  String get encryptedWithAppPin => 'Encrypted with App PIN';

  @override
  String encryptionFailed(String error) {
    return 'Encryption failed: $error';
  }

  @override
  String get backupSavedSuccessfully => 'Backup saved successfully';

  @override
  String get savedToFiles => 'Saved to \"Files\" App > On My iPhone > Flauth';

  @override
  String savedTo(String path) {
    return 'Saved to: $path';
  }

  @override
  String get saveBackupFile => 'Save Backup File';

  @override
  String exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String importedAccounts(int count) {
    return 'Successfully imported $count new accounts';
  }

  @override
  String get noNewAccountsAdded =>
      'No new accounts added (duplicates or empty)';

  @override
  String importFailed(String error) {
    return 'Import failed: $error';
  }

  @override
  String get pleaseConfigureWebdav => 'Please configure WebDAV first';

  @override
  String get uploadedSuccessfully => 'Uploaded successfully';

  @override
  String uploadFailed(String error) {
    return 'Upload failed: $error';
  }

  @override
  String syncedAccounts(int count) {
    return 'Successfully synced $count new accounts';
  }

  @override
  String get alreadyUpToDate =>
      'Already up to date. No new accounts found in Cloud.';

  @override
  String downloadFailed(String error) {
    return 'Download failed: $error';
  }

  @override
  String decryptionFailed(String error) {
    return 'Decryption failed: $error';
  }

  @override
  String get encryptBackup => 'Encrypt Backup?';

  @override
  String get encryptBackupDesc =>
      'Protect your backup with a password. If you lose this password, you cannot restore your accounts.';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get minSixCharacters => 'Min 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get skipPlainText => 'Skip (Plain Text)';

  @override
  String get encrypt => 'Encrypt';

  @override
  String get decryptBackup => 'Decrypt Backup';

  @override
  String get fileIsEncrypted =>
      'This file is encrypted. Please enter the password.';

  @override
  String get unlock => 'Unlock';

  @override
  String get securitySettings => 'Security Settings';

  @override
  String get setupPinBiometrics => 'Setup PIN & Biometrics';

  @override
  String get github => 'GitHub';

  @override
  String get githubUrl => 'github.com/jiacai2050/flauth';

  @override
  String get feedbackAndSupport => 'Feedback & Support';

  @override
  String get appDescription =>
      'A privacy-first, fully open-source TOTP authenticator for Android, macOS, Windows, and Linux.';

  @override
  String version(String version, String buildNumber) {
    return 'Version $version ($buildNumber)';
  }

  @override
  String get loading => 'Loading...';

  @override
  String get webdavConfiguration => 'WebDAV Configuration';

  @override
  String get serverUrl => 'Server URL';

  @override
  String get username => 'Username';

  @override
  String get remotePath => 'Remote Path (Optional)';

  @override
  String get leaveEmptyForRoot => 'Leave empty for root directory';

  @override
  String get fullBackupPathPreview => 'Full Backup Path Preview:';

  @override
  String get pleaseEnterServerUrl => 'Please enter server URL';

  @override
  String get urlIsRequired => 'URL is required';

  @override
  String get usernameIsRequired => 'Username is required';

  @override
  String get passwordIsRequired => 'Password is required';

  @override
  String get testConnectionAndSave => 'Test Connection & Save';

  @override
  String get connectionSuccessful => 'Connection successful & Saved!';

  @override
  String connectionFailed(String error) {
    return 'Connection failed: $error';
  }

  @override
  String get settings => 'Settings';

  @override
  String get addAccount => 'Add Account';

  @override
  String get addManually => 'Add Manually';

  @override
  String get issuerLabel => 'Issuer';

  @override
  String get issuerHint => 'e.g. Google, GitHub';

  @override
  String get accountName => 'Account Name';

  @override
  String get accountNameHint => 'e.g. user@example.com';

  @override
  String get secretKey => 'Secret Key';

  @override
  String get secretKeyHint => 'Base32 encoded secret';

  @override
  String get secretKeyRequired => 'Secret key is required';

  @override
  String get invalidSecretKey => 'Invalid Base32 secret key';

  @override
  String get add => 'Add';

  @override
  String get tapToAddAccount => 'Tap + to add an account';

  @override
  String get codeCopied => 'Code copied to clipboard';

  @override
  String get invalidOtpauthScheme => 'Invalid otpauth URI: unsupported scheme';

  @override
  String get uriMissingSecret => 'No secret found in the QR code';

  @override
  String serverRespondedWithStatus(int statusCode) {
    return 'Server responded with status $statusCode';
  }

  @override
  String get invalidBackupFormat => 'Invalid backup format';

  @override
  String get decryptFailedInvalidPassword =>
      'Wrong password or corrupted backup file';

  @override
  String get issuerOptionalLabel => 'Issuer (optional)';

  @override
  String get accountNameRequired => 'Account name is required';

  @override
  String get general => 'General';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Follow system';

  @override
  String get languageChinese => '简体中文';

  @override
  String get languageEnglish => 'English';
}
