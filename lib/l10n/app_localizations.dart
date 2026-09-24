import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Flauth'**
  String get appTitle;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @importExport.
  ///
  /// In en, this message translates to:
  /// **'Import / Export'**
  String get importExport;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @noAccountsYet.
  ///
  /// In en, this message translates to:
  /// **'No accounts yet'**
  String get noAccountsYet;

  /// No description provided for @tapToScanQr.
  ///
  /// In en, this message translates to:
  /// **'Tap the button below to scan a QR code'**
  String get tapToScanQr;

  /// No description provided for @protectYourAccounts.
  ///
  /// In en, this message translates to:
  /// **'Protect your accounts'**
  String get protectYourAccounts;

  /// No description provided for @protectYourAccountsDesc.
  ///
  /// In en, this message translates to:
  /// **'It is highly recommended to set up a PIN to secure your 2FA tokens. Would you like to do it now?'**
  String get protectYourAccountsDesc;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @setupNow.
  ///
  /// In en, this message translates to:
  /// **'Setup Now'**
  String get setupNow;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @pinProtection.
  ///
  /// In en, this message translates to:
  /// **'PIN Protection'**
  String get pinProtection;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @biometricUnlock.
  ///
  /// In en, this message translates to:
  /// **'Biometric Unlock'**
  String get biometricUnlock;

  /// No description provided for @biometricSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use FaceID / Fingerprint'**
  String get biometricSubtitle;

  /// No description provided for @biometricReason.
  ///
  /// In en, this message translates to:
  /// **'Please authenticate to access Flauth'**
  String get biometricReason;

  /// No description provided for @usePinForBackup.
  ///
  /// In en, this message translates to:
  /// **'Use PIN for Backup'**
  String get usePinForBackup;

  /// No description provided for @usePinForBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically use your App PIN to encrypt/decrypt backups'**
  String get usePinForBackupSubtitle;

  /// No description provided for @setNewPin.
  ///
  /// In en, this message translates to:
  /// **'Set New PIN'**
  String get setNewPin;

  /// No description provided for @confirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPin;

  /// No description provided for @enterSixDigitPin.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit PIN'**
  String get enterSixDigitPin;

  /// No description provided for @reEnterToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Re-enter to confirm'**
  String get reEnterToConfirm;

  /// No description provided for @pinSetSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'PIN Set Successfully'**
  String get pinSetSuccessfully;

  /// No description provided for @pinsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match. Try again.'**
  String get pinsDoNotMatch;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enterPin;

  /// No description provided for @incorrectPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN'**
  String get incorrectPin;

  /// No description provided for @lockedForSeconds.
  ///
  /// In en, this message translates to:
  /// **'Locked for {seconds}s'**
  String lockedForSeconds(int seconds);

  /// No description provided for @attemptsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} attempts remaining'**
  String attemptsRemaining(int count);

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// No description provided for @startScanning.
  ///
  /// In en, this message translates to:
  /// **'Start Scanning'**
  String get startScanning;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @flashOn.
  ///
  /// In en, this message translates to:
  /// **'Flash On'**
  String get flashOn;

  /// No description provided for @flashOff.
  ///
  /// In en, this message translates to:
  /// **'Flash Off'**
  String get flashOff;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to scan QR codes'**
  String get cameraPermissionRequired;

  /// No description provided for @invalidQrCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR Code: Not an authenticator URI'**
  String get invalidQrCode;

  /// No description provided for @scanError.
  ///
  /// In en, this message translates to:
  /// **'Scan error: {error}'**
  String scanError(String error);

  /// No description provided for @failedToStartScanner.
  ///
  /// In en, this message translates to:
  /// **'Failed to start scanner: {error}'**
  String failedToStartScanner(String error);

  /// No description provided for @addedAccount.
  ///
  /// In en, this message translates to:
  /// **'Added account: {name}'**
  String addedAccount(String name);

  /// No description provided for @accountAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Account already exists: {name}'**
  String accountAlreadyExists(String name);

  /// No description provided for @failedToAddAccount.
  ///
  /// In en, this message translates to:
  /// **'Failed to add account: {error}'**
  String failedToAddAccount(String error);

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this account? This cannot be undone.'**
  String get deleteAccountConfirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted'**
  String accountDeleted(String name);

  /// No description provided for @codeRevealedAndCopied.
  ///
  /// In en, this message translates to:
  /// **'Code revealed and copied to clipboard'**
  String get codeRevealedAndCopied;

  /// No description provided for @backupAndRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupAndRestore;

  /// No description provided for @localFile.
  ///
  /// In en, this message translates to:
  /// **'Local File'**
  String get localFile;

  /// No description provided for @webdavCloud.
  ///
  /// In en, this message translates to:
  /// **'WebDAV Cloud'**
  String get webdavCloud;

  /// No description provided for @webdavSettings.
  ///
  /// In en, this message translates to:
  /// **'WebDAV Settings'**
  String get webdavSettings;

  /// No description provided for @localStorage.
  ///
  /// In en, this message translates to:
  /// **'Local Storage'**
  String get localStorage;

  /// No description provided for @localStorageDesc.
  ///
  /// In en, this message translates to:
  /// **'Save backups to your device or import from local files.'**
  String get localStorageDesc;

  /// No description provided for @exportToFile.
  ///
  /// In en, this message translates to:
  /// **'Export to File'**
  String get exportToFile;

  /// No description provided for @importFromFile.
  ///
  /// In en, this message translates to:
  /// **'Import from File'**
  String get importFromFile;

  /// No description provided for @webdavCloudDesc.
  ///
  /// In en, this message translates to:
  /// **'Sync backups with your private cloud (Nextcloud, InfiniCloud etc).'**
  String get webdavCloudDesc;

  /// No description provided for @uploadToCloud.
  ///
  /// In en, this message translates to:
  /// **'Upload to Cloud'**
  String get uploadToCloud;

  /// No description provided for @restoreFromCloud.
  ///
  /// In en, this message translates to:
  /// **'Restore from Cloud'**
  String get restoreFromCloud;

  /// No description provided for @cloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud'**
  String get cloud;

  /// No description provided for @synced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get synced;

  /// No description provided for @noAccountsToExport.
  ///
  /// In en, this message translates to:
  /// **'No accounts to export'**
  String get noAccountsToExport;

  /// No description provided for @encryptedWithAppPin.
  ///
  /// In en, this message translates to:
  /// **'Encrypted with App PIN'**
  String get encryptedWithAppPin;

  /// No description provided for @encryptionFailed.
  ///
  /// In en, this message translates to:
  /// **'Encryption failed: {error}'**
  String encryptionFailed(String error);

  /// No description provided for @backupSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Backup saved successfully'**
  String get backupSavedSuccessfully;

  /// No description provided for @savedToFiles.
  ///
  /// In en, this message translates to:
  /// **'Saved to \"Files\" App > On My iPhone > Flauth'**
  String get savedToFiles;

  /// No description provided for @savedTo.
  ///
  /// In en, this message translates to:
  /// **'Saved to: {path}'**
  String savedTo(String path);

  /// No description provided for @saveBackupFile.
  ///
  /// In en, this message translates to:
  /// **'Save Backup File'**
  String get saveBackupFile;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(String error);

  /// No description provided for @importedAccounts.
  ///
  /// In en, this message translates to:
  /// **'Successfully imported {count} new accounts'**
  String importedAccounts(int count);

  /// No description provided for @noNewAccountsAdded.
  ///
  /// In en, this message translates to:
  /// **'No new accounts added (duplicates or empty)'**
  String get noNewAccountsAdded;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String importFailed(String error);

  /// No description provided for @pleaseConfigureWebdav.
  ///
  /// In en, this message translates to:
  /// **'Please configure WebDAV first'**
  String get pleaseConfigureWebdav;

  /// No description provided for @uploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Uploaded successfully'**
  String get uploadedSuccessfully;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed: {error}'**
  String uploadFailed(String error);

  /// No description provided for @syncedAccounts.
  ///
  /// In en, this message translates to:
  /// **'Successfully synced {count} new accounts'**
  String syncedAccounts(int count);

  /// No description provided for @alreadyUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Already up to date. No new accounts found in Cloud.'**
  String get alreadyUpToDate;

  /// No description provided for @downloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed: {error}'**
  String downloadFailed(String error);

  /// No description provided for @decryptionFailed.
  ///
  /// In en, this message translates to:
  /// **'Decryption failed: {error}'**
  String decryptionFailed(String error);

  /// No description provided for @encryptBackup.
  ///
  /// In en, this message translates to:
  /// **'Encrypt Backup?'**
  String get encryptBackup;

  /// No description provided for @encryptBackupDesc.
  ///
  /// In en, this message translates to:
  /// **'Protect your backup with a password. If you lose this password, you cannot restore your accounts.'**
  String get encryptBackupDesc;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @minSixCharacters.
  ///
  /// In en, this message translates to:
  /// **'Min 6 characters'**
  String get minSixCharacters;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @skipPlainText.
  ///
  /// In en, this message translates to:
  /// **'Skip (Plain Text)'**
  String get skipPlainText;

  /// No description provided for @encrypt.
  ///
  /// In en, this message translates to:
  /// **'Encrypt'**
  String get encrypt;

  /// No description provided for @decryptBackup.
  ///
  /// In en, this message translates to:
  /// **'Decrypt Backup'**
  String get decryptBackup;

  /// No description provided for @fileIsEncrypted.
  ///
  /// In en, this message translates to:
  /// **'This file is encrypted. Please enter the password.'**
  String get fileIsEncrypted;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @securitySettings.
  ///
  /// In en, this message translates to:
  /// **'Security Settings'**
  String get securitySettings;

  /// No description provided for @setupPinBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Setup PIN & Biometrics'**
  String get setupPinBiometrics;

  /// No description provided for @github.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get github;

  /// No description provided for @githubUrl.
  ///
  /// In en, this message translates to:
  /// **'github.com/jiacai2050/flauth'**
  String get githubUrl;

  /// No description provided for @feedbackAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Feedback & Support'**
  String get feedbackAndSupport;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'A privacy-first, fully open-source TOTP authenticator for Android, macOS, Windows, and Linux.'**
  String get appDescription;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version} ({buildNumber})'**
  String version(String version, String buildNumber);

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @webdavConfiguration.
  ///
  /// In en, this message translates to:
  /// **'WebDAV Configuration'**
  String get webdavConfiguration;

  /// No description provided for @serverUrl.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get serverUrl;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @remotePath.
  ///
  /// In en, this message translates to:
  /// **'Remote Path (Optional)'**
  String get remotePath;

  /// No description provided for @leaveEmptyForRoot.
  ///
  /// In en, this message translates to:
  /// **'Leave empty for root directory'**
  String get leaveEmptyForRoot;

  /// No description provided for @fullBackupPathPreview.
  ///
  /// In en, this message translates to:
  /// **'Full Backup Path Preview:'**
  String get fullBackupPathPreview;

  /// No description provided for @pleaseEnterServerUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter server URL'**
  String get pleaseEnterServerUrl;

  /// No description provided for @urlIsRequired.
  ///
  /// In en, this message translates to:
  /// **'URL is required'**
  String get urlIsRequired;

  /// No description provided for @usernameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameIsRequired;

  /// No description provided for @passwordIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordIsRequired;

  /// No description provided for @testConnectionAndSave.
  ///
  /// In en, this message translates to:
  /// **'Test Connection & Save'**
  String get testConnectionAndSave;

  /// No description provided for @connectionSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Connection successful & Saved!'**
  String get connectionSuccessful;

  /// No description provided for @connectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed: {error}'**
  String connectionFailed(String error);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @addAccount.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get addAccount;

  /// No description provided for @addManually.
  ///
  /// In en, this message translates to:
  /// **'Add Manually'**
  String get addManually;

  /// No description provided for @issuerLabel.
  ///
  /// In en, this message translates to:
  /// **'Issuer'**
  String get issuerLabel;

  /// No description provided for @issuerHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Google, GitHub'**
  String get issuerHint;

  /// No description provided for @accountName.
  ///
  /// In en, this message translates to:
  /// **'Account Name'**
  String get accountName;

  /// No description provided for @accountNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. user@example.com'**
  String get accountNameHint;

  /// No description provided for @secretKey.
  ///
  /// In en, this message translates to:
  /// **'Secret Key'**
  String get secretKey;

  /// No description provided for @secretKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Base32 encoded secret'**
  String get secretKeyHint;

  /// No description provided for @secretKeyRequired.
  ///
  /// In en, this message translates to:
  /// **'Secret key is required'**
  String get secretKeyRequired;

  /// No description provided for @invalidSecretKey.
  ///
  /// In en, this message translates to:
  /// **'Invalid Base32 secret key'**
  String get invalidSecretKey;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @tapToAddAccount.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add an account'**
  String get tapToAddAccount;

  /// No description provided for @codeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied to clipboard'**
  String get codeCopied;

  /// No description provided for @invalidOtpauthScheme.
  ///
  /// In en, this message translates to:
  /// **'Invalid otpauth URI: unsupported scheme'**
  String get invalidOtpauthScheme;

  /// No description provided for @uriMissingSecret.
  ///
  /// In en, this message translates to:
  /// **'No secret found in the QR code'**
  String get uriMissingSecret;

  /// No description provided for @serverRespondedWithStatus.
  ///
  /// In en, this message translates to:
  /// **'Server responded with status {statusCode}'**
  String serverRespondedWithStatus(int statusCode);

  /// No description provided for @invalidBackupFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid backup format'**
  String get invalidBackupFormat;

  /// No description provided for @decryptFailedInvalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password or corrupted backup file'**
  String get decryptFailedInvalidPassword;

  /// No description provided for @issuerOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Issuer (optional)'**
  String get issuerOptionalLabel;

  /// No description provided for @accountNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Account name is required'**
  String get accountNameRequired;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get languageSystem;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get languageChinese;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
