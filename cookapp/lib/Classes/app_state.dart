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

  static List<DropdownMenuItem<String>> locales = const [
    DropdownMenuItem(
      value: 'en',
      child: Text("English"),
    ),
    DropdownMenuItem(
      value: 'pt',
      child: Text("Português"),
    ),
  ];
}
