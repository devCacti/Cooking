import 'package:cookapp/Classes/language.dart';
import 'package:cookapp/Classes/user.dart';
import 'package:cookapp/Settings/settings.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  User? user;
  Locale _locale = const Locale('pt');

  Locale get locale => _locale;
  bool get isLoggedIn => user != null && user!.cookie.isNotEmpty;

  // User Related Methods
  Future<void> login(Login l) async {
    Login login = Login(
      email: l.email,
      password: l.password,
      username: l.username,
      name: l.name,
      surname: l.surname,
    );

    user = await login.send();
    notifyListeners();
  }

  Future<void> register(Register r, BuildContext context) async {
    Register register = Register(
      email: r.email,
      password: r.password,
      confirmPassword: r.password,
      username: r.username,
      name: r.name,
      surname: r.surname,
    );

    user = await register.send(context);
    notifyListeners();
  }

  void logout() async {
    await user?.delete();
    user = User.defaultU();
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
