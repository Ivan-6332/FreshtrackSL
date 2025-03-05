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
      'goodMorning': 'Good Morning',
      'viewHistory': 'View History',
      'highlights': 'Highlights',
      'favorites': 'Favorites',
      'search': 'Search...',
      'todaysHighlights': 'Today\'s Highlights',
      'yourFavorites': 'Your Favorites',
      'explore': 'Explore',
      'mapTabContent': 'Map Tab Content',
    },
    'si': {
      'username': 'පරිශීලක නාමය',
      'email': 'විද්‍යුත් තැපෑල',
      'language': 'භාෂාව',
      'lightTheme': 'සැහැල්ලු තේමාව',
      'notifications': 'දැනුම්දීම්',
      'accountSettings': 'ගිණුම් සැකසුම්',
      'legalInfo': 'නීතිමය තොරතුරු',
      'helpSupport': 'උදව් සහ සහාය',
      'logOut': 'පිටවීම',
      'goodMorning': 'සුභ උදෑසනක්',
      'viewHistory': 'ඉතිහාසය බලන්න',
      'highlights': 'විශේෂාංග',
      'favorites': 'ප්‍රියතම',
      'search': 'සෙවීම...',
      'todaysHighlights': 'විශේෂාංග',
      'yourFavorites': 'ඔබේ ප්‍රියතම',
      'explore': 'ගවේෂණය',
      'mapTabContent': 'සිතියම් පටිත්තේ අන්තර්ගතය',
    },
    'ta': {
      'username': 'பயனர் பெயர்',
      'email': 'மின்னஞ்சல்',
      'language': 'மொழி',
      'lightTheme': 'ஒளி தீம்',
      'notifications': 'அறிவிப்புகள்',
      'accountSettings': 'கணக்கு அமைப்புகள்',
      'legalInfo': 'சட்டத் தகவல்',
      'helpSupport': 'உதவி & ஆதரவு',
      'logOut': 'வெளியேறு',
      'goodMorning': 'காலை வணக்கம்',
      'viewHistory': 'வரலாறு பார்க்க',
      'highlights': 'சிறப்பம்சங்கள்',
      'favorites': 'பிடித்தவை',
      'search': 'தேடல்...',
      'todaysHighlights': 'இன்றைய சிறப்பம்சங்கள்',
      'yourFavorites': 'உங்கள் பிடித்தவை',
      'explore': 'ஆராயுங்கள்',
      'mapTabContent': 'வரைபடக் கூறின் உள்ளடக்கம்',
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
