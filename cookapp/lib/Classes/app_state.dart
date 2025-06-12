import 'package:cookapp/Classes/user.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  User? user;
  Locale _locale = const Locale('en');

  Locale get locale => _locale;
  bool get isLoggedIn => user != null;

  // User Related Methods
  void login(User u) {
    user = u;
    notifyListeners();
  }

  void logout() {
    user = null;
    notifyListeners();
  }

  // Locale Related Methods
  Locale get currentLocale => _locale;

  // Method extension for Locale to get the language code
  String get languageCode => _locale.languageCode;

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }

  String getLanguageName(Locale code) {
    switch (code.languageCode) {
      case 'en':
        return 'English';
      case 'pt':
        return 'Português';
      default:
        return 'Unknown';
    }
  }

  static List<Locale> locales = const [
    Locale('en'),
    Locale('pt'),
  ];
}
