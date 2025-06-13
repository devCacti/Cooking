import 'package:cookapp/Classes/language.dart';
import 'package:cookapp/Classes/user.dart';
import 'package:cookapp/Settings/settings.dart';
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
    Settings.setLanguage(Language.getLanguageType(newLocale.languageCode));
  }

  Future<void> getLocale() async {
    String languageCode = await Settings.getLanguage();
    _locale = Language.getLocale(languageCode);
    notifyListeners();
  }

  static List<Locale> locales = const [
    Locale('en'),
    Locale('pt'),
  ];
}
