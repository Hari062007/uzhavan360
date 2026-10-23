import 'package:flutter/material.dart';
import '../core/services/storage_service.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ta'); // Tamil by default

  Locale get locale => _locale;
  bool get isTamil => _locale.languageCode == 'ta';

  LocaleProvider() {
    _loadSavedLocale();
  }

  void _loadSavedLocale() {
    final savedCode = StorageService.getLanguage();
    _locale = Locale(savedCode);
    notifyListeners();
  }

  Future<void> setLocale(String languageCode) async {
    if (_locale.languageCode == languageCode) return;
    _locale = Locale(languageCode);
    await StorageService.setLanguage(languageCode);
    notifyListeners();
  }
}
