import 'package:flutter/widgets.dart';
import '../services/storage_service.dart';

/// Holds the app language. A `null` [locale] means "follow the system language".
class LocaleProvider extends ChangeNotifier {
  LocaleProvider(this._storage);

  final StorageService _storage;

  Locale? _locale;
  Locale? get locale => _locale;

  Future<void> load() async {
    final languageCode = await _storage.getLocale();
    if (languageCode == null) return;
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> select(Locale? locale) async {
    if (locale?.languageCode == _locale?.languageCode) return;
    _locale = locale;
    notifyListeners();
    await _storage.saveLocale(locale?.languageCode);
  }
}
