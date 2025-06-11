// ignore_for_file: unnecessary_const

import 'package:cookapp/Classes/app_state.dart';
import 'package:cookapp/Classes/server_info.dart';
import 'package:cookapp/Pages/Elements/drawer_header.dart';
import 'package:cookapp/Pages/Elements/logged_in_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Classes/user.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  User? user = User.defaultU();
  @override
  void initState() {
    super.initState();
    user!.getInstance().then(
          (value) => setState(() {}),
        );

    Settings.getDarkMode().then(
      (value) => setState(() {
        darkMode = value;
      }),
    );
  }

  Settings settings = Settings.defaultS();

  String page = "details";

  bool isLogged = false;

  bool darkMode = themeNotifier.value == ThemeMode.dark ? true : false;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final loc = AppLocalizations.of(context)!;

    setState(() {
      isLogged = user!.guid != "";
    });

    final drawerItems = isLogged && user != null
        ? loggedInSettings(context, user!)
        : ListView(
            children: [
              anonymousDrawerHeader,
              //* Login and Register buttons
              ListTile(
                title: const Text("Entrar"),
                leading: const Icon(Icons.login),
                onTap: () {
                  //LoginPage is the page that we want to open on click.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  ).then((value) {
                    user!.getInstance().then((value) => setState(() {
                          isLogged = user!.guid != "";
                        }));
                  });
                },
              ),
              ListTile(
                title: const Text("Registar"),
                leading: const Icon(Icons.app_registration),
                onTap: () {
                  //RegisterPage is the page that we want to open on click.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
              ),
              //* Divider
              const Divider(),
              //* Go back button
              ListTile(
                title: const Text("Voltar"),
                leading: const Icon(Icons.arrow_back),
                onTap: () {
                  //? Twice so that it closes the drawer and then the page
                  Navigator.pop(context); // Close the drawer
                  Navigator.pop(context); // Close the page
                },
              ),
            ],
          );
    return Scaffold(
      appBar: AppBar(
        title: const Text("A Minha Conta"),
        // Button on the right side of the app bar to exit
        actions: [
          IconButton(
            icon: const Icon(
              Icons.home_rounded,
              opticalSize: 50,
            ),
            iconSize: 30.0,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Semantics(
        container: true,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Cooking",
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Version text
                Text(
                  version,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                Text(
                  loc.settings,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //? Dark mode switch
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc.darkMode,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: darkMode,
                      onChanged: (value) {
                        darkMode = value;
                        settings.setDarkMode(value);
                        setState(() {
                          themeNotifier.value = darkMode ? ThemeMode.dark : ThemeMode.light;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    //Language selection
                    Text(
                      loc.language,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    DropdownButton<String>(
                      value: appState.locale.languageCode,
                      icon: const Icon(Icons.language),
                      onChanged: (value) {
                        if (value != null) {
                          appState.setLocale(Locale(value));
                        }
                      },
                      items: AppState.locales,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        semanticLabel: "Menu de Navegação",
        child: drawerItems,
      ),
    );
  }
}
