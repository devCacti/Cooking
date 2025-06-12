import 'package:flutter/material.dart';

enum LanguageType {
  en, // English
  pt, // Portuguese
}

class Language {
  static String getLanguageCode(LanguageType type) {
    switch (type) {
      case LanguageType.en:
        return 'en';
      case LanguageType.pt:
        return 'pt';
      default:
        return 'en'; // Default to English if unknown
    }
  }

  static LanguageType getLanguageType(String code) {
    switch (code) {
      case 'en':
        return LanguageType.en;
      case 'pt':
        return LanguageType.pt;
      default:
        return LanguageType.en; // Default to English if unknown
    }
  }

  static String getLanguageName(LanguageType type) {
    switch (type) {
      case LanguageType.en:
        return 'English';
      case LanguageType.pt:
        return 'Português';
      default:
        return 'Unknown';
    }
  }

  static Locale getLocale(String code) {
    return Locale(getLanguageCode(getLanguageType(code)));
  }
}
