import 'dart:developer' as developer;

import 'package:cookapp/Classes/language.dart';
import 'package:cookapp/Classes/snackbars.dart';
import 'package:cookapp/Classes/user.dart';
import 'package:cookapp/Settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppState extends ChangeNotifier {
  User? user;
  Locale _locale = const Locale('pt');
  bool _useSecureStorage = true;
  bool _canUseSecureStorage = false;

  Locale get locale => _locale;
  bool get isLoggedIn => user != null && user!.cookie.isNotEmpty;
  bool get useSecureStorage => _useSecureStorage;
  bool get canUseSecureStorage => _canUseSecureStorage;

  Future<bool> getUseSecureStorage(BuildContext context) async {
    _useSecureStorage = await Settings.getUseSecureStorage(context);
    developer.log("Use Secure Storage: $_useSecureStorage");

    notifyListeners();
    return _useSecureStorage;
  }

  Future<void> setUseSecureStorage(bool value, BuildContext context) async {
    if (_useSecureStorage == value) return; // No change, no need to notify
    user?.delete(context); // Delete user if changing secure storage setting
    user = null; // Reset user when changing secure storage setting
    _useSecureStorage = value;
    developer.log("Use Secure Storage: $_useSecureStorage");

    await Settings.setUseSecureStorage(value, context);
    notifyListeners();
  }

  Future<bool> getCanUseSecureStorage(BuildContext context) async {
    _canUseSecureStorage = await Settings.canUseSecureStorage(context);
    _useSecureStorage = _canUseSecureStorage; // Update useSecureStorage based on canUseSecureStorage
    developer.log("Can Use Secure Storage: $_canUseSecureStorage");
    return _canUseSecureStorage;
  }

  // User Related Methods
  Future<void> login(Login l, BuildContext context) async {
    Login login = Login(
      email: l.email,
      password: l.password,
      username: l.username,
      name: l.name,
      surname: l.surname,
    );

    user = await login.send(context);

    if (user == null || user!.cookie.isEmpty) {
      // If login fails, show an error message
      // ignore: use_build_context_synchronously
      showSnackbar(context, 'Email ou password errados.', type: SnackBarType.error, isBold: true);
    }
    notifyListeners();
  }

  Future<void> register(Register r, BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    Register register = Register(
      email: r.email,
      password: r.password,
      confirmPassword: r.password,
      username: r.username,
      name: r.name,
      surname: r.surname,
    );

    user = await register.send(context);

    if (user == null || user!.cookie.isEmpty) {
      // If registration fails, show an error message
      // ignore: use_build_context_synchronously
      showSnackbar(context, loc.register_failed, type: SnackBarType.error, isBold: true);
    }
    notifyListeners();
  }

  void logout(BuildContext context) async {
    await user?.delete(context);
    user = User.defaultU();
    notifyListeners();
  }

  // Locale Related Methods
  Locale get currentLocale => _locale;

  // Method extension for Locale to get the language code
  String get languageCode => _locale.languageCode;

  void setLocale(Locale newLocale, BuildContext context) {
    _locale = newLocale;
    Settings.setLanguage(Language.getLanguageType(newLocale.languageCode), context);
    notifyListeners();
  }

  Future<void> getLocale(BuildContext context) async {
    String languageCode = await Settings.getLanguage(context);
    _locale = Language.getLocale(languageCode);
    notifyListeners();
  }

  static List<Locale> locales = const [
    Locale('en'),
    Locale('pt'),
  ];
}
