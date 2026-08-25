import 'package:flutter/material.dart';

enum AppLanguage {
  portuguese,
  english,
}

extension AppLanguageInfo on AppLanguage {
  String get code => this == AppLanguage.portuguese ? 'pt_BR' : 'en_US';
  String get speechLocale => code;
  String get ttsLocale => this == AppLanguage.portuguese ? 'pt-PT' : 'en-US';
  Locale get locale => this == AppLanguage.portuguese ? const Locale('pt', 'PT') : const Locale('en', 'US');
  String get label => this == AppLanguage.portuguese ? 'Português' : 'English';
}

class AppSettingsController extends ChangeNotifier {
  AppLanguage _language = AppLanguage.portuguese;

  AppLanguage get language => _language;

  void setLanguage(AppLanguage value) {
    if (_language == value) return;
    _language = value;
    notifyListeners();
  }
}

final appSettings = AppSettingsController();
