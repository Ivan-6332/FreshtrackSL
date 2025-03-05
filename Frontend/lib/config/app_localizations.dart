import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'username': 'Username',
      'email': 'Email',
      'language': 'Language',
      'lightTheme': 'Light Theme',
      'notifications': 'Notifications',
      'accountSettings': 'Account Settings',
      'legalInfo': 'Legal Info',
      'helpSupport': 'Help & Support',
      'logOut': 'Log Out',
    },
    'si': {
      'username': '[සිංහල] Username',
      'email': '[සිංහල] Email',
      'language': 'භාෂාව',
      'lightTheme': '[සිංහල] Light Theme',
      'notifications': '[සිංහල] Notifications',
      'accountSettings': '[සිංහල] Account Settings',
      'legalInfo': '[සිංහල] Legal Info',
      'helpSupport': '[සිංහල] Help & Support',
      'logOut': '[සිංහල] Log Out',
    },
    'ta': {
      'username': '[தமிழ்] Username',
      'email': '[தமிழ்] Email',
      'language': 'மொழி',
      'lightTheme': '[தமிழ்] Light Theme',
      'notifications': '[தமிழ்] Notifications',
      'accountSettings': '[தமிழ்] Account Settings',
      'legalInfo': '[தமிழ்] Legal Info',
      'helpSupport': '[தமிழ்] Help & Support',
      'logOut': '[தமிழ்] Log Out',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key]!;
  }

  static const supportedLocales = [
    Locale('en', ''), // English
    Locale('si', ''), // Sinhala
    Locale('ta', ''), // Tamil
  ];
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'si', 'ta'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
