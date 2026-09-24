// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Flauth';

  @override
  String get scan => '扫描';

  @override
  String get importExport => '导入 / 导出';

  @override
  String get about => '关于';

  @override
  String get noAccountsYet => '暂无账户';

  @override
  String get tapToScanQr => '点击下方按钮扫描二维码';

  @override
  String get protectYourAccounts => '保护您的账户';

  @override
  String get protectYourAccountsDesc => '强烈建议设置 PIN 码来保护您的两步验证令牌。是否现在设置？';

  @override
  String get later => '稍后';

  @override
  String get setupNow => '立即设置';

  @override
  String get security => '安全';

  @override
  String get pinProtection => 'PIN 码保护';

  @override
  String get enabled => '已启用';

  @override
  String get disabled => '已禁用';

  @override
  String get changePin => '更改 PIN 码';

  @override
  String get biometricUnlock => '生物识别解锁';

  @override
  String get biometricSubtitle => '使用面容 / 指纹识别';

  @override
  String get biometricReason => '请验证身份以访问 Flauth';

  @override
  String get usePinForBackup => '使用 PIN 码加密备份';

  @override
  String get usePinForBackupSubtitle => '自动使用应用 PIN 码加密/解密备份文件';

  @override
  String get setNewPin => '设置新 PIN 码';

  @override
  String get confirmPin => '确认 PIN 码';

  @override
  String get enterSixDigitPin => '输入 6 位 PIN 码';

  @override
  String get reEnterToConfirm => '再次输入以确认';

  @override
  String get pinSetSuccessfully => 'PIN 码设置成功';

  @override
  String get pinsDoNotMatch => '两次输入不一致，请重试。';

  @override
  String get enterPin => '输入 PIN 码';

  @override
  String get incorrectPin => 'PIN 码错误';

  @override
  String lockedForSeconds(int seconds) {
    return '已锁定 $seconds 秒';
  }

  @override
  String attemptsRemaining(int count) {
    return '剩余 $count 次尝试机会';
  }

  @override
  String get scanQrCode => '扫描二维码';

  @override
  String get startScanning => '开始扫描';

  @override
  String get cancel => '取消';

  @override
  String get flashOn => '开启闪光灯';

  @override
  String get flashOff => '关闭闪光灯';

  @override
  String get cameraPermissionRequired => '扫描二维码需要相机权限';

  @override
  String get invalidQrCode => '无效的二维码：不是认证器 URI';

  @override
  String scanError(String error) {
    return '扫描错误：$error';
  }

  @override
  String failedToStartScanner(String error) {
    return '启动扫描器失败：$error';
  }

  @override
  String addedAccount(String name) {
    return '已添加账户：$name';
  }

  @override
  String accountAlreadyExists(String name) {
    return '账户已存在：$name';
  }

  @override
  String failedToAddAccount(String error) {
    return '添加账户失败：$error';
  }

  @override
  String get deleteAccount => '删除账户';

  @override
  String get deleteAccountConfirm => '确定要删除此账户吗？此操作无法撤销。';

  @override
  String get delete => '删除';

  @override
  String accountDeleted(String name) {
    return '已删除 $name';
  }

  @override
  String get codeRevealedAndCopied => '验证码已显示并复制到剪贴板';

  @override
  String get backupAndRestore => '备份与恢复';

  @override
  String get localFile => '本地文件';

  @override
  String get webdavCloud => 'WebDAV 云端';

  @override
  String get webdavSettings => 'WebDAV 设置';

  @override
  String get localStorage => '本地存储';

  @override
  String get localStorageDesc => '将备份保存到设备或从本地文件导入。';

  @override
  String get exportToFile => '导出到文件';

  @override
  String get importFromFile => '从文件导入';

  @override
  String get webdavCloudDesc => '与您的私有云同步备份（Nextcloud、InfiniCloud 等）。';

  @override
  String get uploadToCloud => '上传到云端';

  @override
  String get restoreFromCloud => '从云端恢复';

  @override
  String get cloud => '云端';

  @override
  String get synced => '已同步';

  @override
  String get noAccountsToExport => '没有可导出的账户';

  @override
  String get encryptedWithAppPin => '已使用应用 PIN 码加密';

  @override
  String encryptionFailed(String error) {
    return '加密失败：$error';
  }

  @override
  String get backupSavedSuccessfully => '备份保存成功';

  @override
  String get savedToFiles => '已保存到「文件」App > 我的 iPhone > Flauth';

  @override
  String savedTo(String path) {
    return '已保存到：$path';
  }

  @override
  String get saveBackupFile => '保存备份文件';

  @override
  String exportFailed(String error) {
    return '导出失败：$error';
  }

  @override
  String importedAccounts(int count) {
    return '成功导入 $count 个新账户';
  }

  @override
  String get noNewAccountsAdded => '没有新增账户（重复或为空）';

  @override
  String importFailed(String error) {
    return '导入失败：$error';
  }

  @override
  String get pleaseConfigureWebdav => '请先配置 WebDAV';

  @override
  String get uploadedSuccessfully => '上传成功';

  @override
  String uploadFailed(String error) {
    return '上传失败：$error';
  }

  @override
  String syncedAccounts(int count) {
    return '成功同步 $count 个新账户';
  }

  @override
  String get alreadyUpToDate => '已是最新，云端没有新账户。';

  @override
  String downloadFailed(String error) {
    return '下载失败：$error';
  }

  @override
  String decryptionFailed(String error) {
    return '解密失败：$error';
  }

  @override
  String get encryptBackup => '加密备份？';

  @override
  String get encryptBackupDesc => '使用密码保护您的备份。如果忘记密码，将无法恢复账户。';

  @override
  String get password => '密码';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get minSixCharacters => '至少 6 个字符';

  @override
  String get passwordsDoNotMatch => '两次密码不一致';

  @override
  String get skipPlainText => '跳过（明文）';

  @override
  String get encrypt => '加密';

  @override
  String get decryptBackup => '解密备份';

  @override
  String get fileIsEncrypted => '此文件已加密，请输入密码。';

  @override
  String get unlock => '解锁';

  @override
  String get securitySettings => '安全设置';

  @override
  String get setupPinBiometrics => '设置 PIN 码和生物识别';

  @override
  String get github => 'GitHub';

  @override
  String get githubUrl => 'github.com/jiacai2050/flauth';

  @override
  String get feedbackAndSupport => '反馈与支持';

  @override
  String get appDescription =>
      '一款隐私优先、完全开源的 TOTP 认证器，支持 Android、macOS、Windows 和 Linux。';

  @override
  String version(String version, String buildNumber) {
    return '版本 $version（$buildNumber）';
  }

  @override
  String get loading => '加载中...';

  @override
  String get webdavConfiguration => 'WebDAV 配置';

  @override
  String get serverUrl => '服务器地址';

  @override
  String get username => '用户名';

  @override
  String get remotePath => '远程路径（可选）';

  @override
  String get leaveEmptyForRoot => '留空则使用根目录';

  @override
  String get fullBackupPathPreview => '完整备份路径预览：';

  @override
  String get pleaseEnterServerUrl => '请输入服务器地址';

  @override
  String get urlIsRequired => 'URL 不能为空';

  @override
  String get usernameIsRequired => '用户名不能为空';

  @override
  String get passwordIsRequired => '密码不能为空';

  @override
  String get testConnectionAndSave => '测试连接并保存';

  @override
  String get connectionSuccessful => '连接成功，已保存！';

  @override
  String connectionFailed(String error) {
    return '连接失败：$error';
  }

  @override
  String get settings => '设置';

  @override
  String get addAccount => '添加账户';

  @override
  String get addManually => '手动添加';

  @override
  String get issuerLabel => '服务名称';

  @override
  String get issuerHint => '例如 Google、GitHub';

  @override
  String get accountName => '账户名';

  @override
  String get accountNameHint => '例如 user@example.com';

  @override
  String get secretKey => '密钥';

  @override
  String get secretKeyHint => 'Base32 编码的密钥';

  @override
  String get secretKeyRequired => '密钥不能为空';

  @override
  String get invalidSecretKey => '无效的 Base32 密钥';

  @override
  String get add => '添加';

  @override
  String get tapToAddAccount => '点击 + 添加账户';
  @override
  String get codeCopied => '验证码已复制到剪贴板';

  @override
  String get invalidOtpauthScheme => '无效的 otpauth 链接：协议不受支持';

  @override
  String get uriMissingSecret => '二维码中未包含密钥';

  @override
  String serverRespondedWithStatus(int statusCode) {
    return '服务器返回状态码 $statusCode';
  }

  @override
  String get invalidBackupFormat => '备份文件格式无效';

  @override
  String get decryptFailedInvalidPassword => '密码错误或备份文件已损坏';

  @override
  String get issuerOptionalLabel => '服务名称（可选）';

  @override
  String get accountNameRequired => '账户名不能为空';

  @override
  String get general => '通用';

  @override
  String get language => '语言';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get languageChinese => '简体中文';

  @override
  String get languageEnglish => 'English';
}
