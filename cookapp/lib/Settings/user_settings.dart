// ignore_for_file: unnecessary_const

import 'package:cookapp/Classes/app_state.dart';
import 'package:cookapp/Classes/language.dart';
import 'package:cookapp/Classes/server_info.dart';
import 'package:cookapp/Pages/Elements/bottom_app_bar.dart';
import 'package:cookapp/Pages/Elements/drawer_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  void initState() {
    super.initState();
    Settings.getDarkMode().then(
      (value) => setState(() {
        darkMode = value;
      }),
    );
  }

  Settings settings = Settings.defaultS();

  bool darkMode = themeNotifier.value == ThemeMode.dark ? true : false;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final loc = AppLocalizations.of(context)!;

    var drawerItems = getDrawerItems(context);

    //developer.log("User Settings: ${appState.user!.cookie}");

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.account_settings),
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
                  ServerInfo.version,
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
                    fontSize: 24,
                    fontWeight: FontWeight.w100,
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
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    // Language selection
                    Text(
                      loc.language,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: Language.getLanguageName(Language.getLanguageType(appState.locale.languageCode)),
                          borderRadius: BorderRadius.circular(15),
                          icon: const Icon(Icons.arrow_drop_down),
                          dropdownColor: Theme.of(context).cardColor,
                          items: AppState.locales.map((locale) {
                            final languageName = Language.getLanguageName(Language.getLanguageType(locale.languageCode));
                            return DropdownMenuItem<String>(
                              value: languageName,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  languageName,
                                  style: TextStyle(
                                    color: themeNotifier.value == ThemeMode.dark ? Colors.white : Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newLanguage) {
                            if (newLanguage != null) {
                              final selectedLocale = AppState.locales.firstWhere(
                                (locale) => Language.getLanguageName(Language.getLanguageType(locale.languageCode)) == newLanguage,
                                orElse: () => AppState.locales.first,
                              );
                              appState.setLocale(selectedLocale);
                            }
                            drawerItems = getDrawerItems(context);
                            // Update the drawer items after changing the language
                            setState(() {});
                          },
                        ),
                      ),
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
      bottomNavigationBar: bottomAppBar(context, PageType.profile),
      floatingActionButton: actionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
