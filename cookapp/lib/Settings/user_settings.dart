// ignore_for_file: unnecessary_const

import 'package:cookapp/Classes/server_info.dart';
import 'package:flutter/material.dart';
import '../Classes/user.dart';
import 'login_page.dart';
import 'register_page.dart';
import '../Functions/show_conf_dialog.dart';
import 'settings.dart';

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

  //TODO: Add user checking logic, if the user is logged in, show the user information, else, show like if isLogged is false
  //* TLDR
  @override
  Widget build(BuildContext context) {
    String name = "${user?.name ?? ""} ${user?.surname ?? ""}";

    final drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(name == " " ? "Sem Nome" : name),
      accountEmail: Text("@${user?.username}" == "@" ? "Sem Username" : "@${user?.username}"),
      currentAccountPicture: const CircleAvatar(
        child: Icon(Icons.person_rounded, size: 42.0),
      ),
      decoration: const BoxDecoration(
        color: Colors.deepPurpleAccent,
      ),
    );

    const anonymousDrawerHeader = UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
      ),
      accountName: Text("Utilizador Anónimo"),
      accountEmail: Text("Faça logon para aceder aos serviços", style: TextStyle(color: Colors.orange)),
      currentAccountPicture: CircleAvatar(
        child: Icon(Icons.person, size: 42.0),
      ),
    );

    setState(() {
      isLogged = user!.guid != "";
    });

    final drawerItems = isLogged
        ? Column(
            children: [
              drawerHeader,
              //* Privacy
              const Text(
                "Nenhuma definição disponível",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                ),
              ),
              const SizedBox(height: 10.0),
              ListTile(
                title: const Text("Privacidade"),
                leading: const Icon(Icons.remove_red_eye),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              //* Divider
              const Divider(),
              //* Account Details
              ListTile(
                title: const Text("Detalhes da Conta"),
                leading: const Icon(Icons.account_circle),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              //* Settings
              ListTile(
                title: const Text("Definições"),
                leading: const Icon(Icons.settings),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              //* Divider
              const Divider(),
              //* About
              ListTile(
                title: const Text("Sobre"),
                leading: const Icon(Icons.info),
                onTap: () {
                  Navigator.pop(context);
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
              ListTile(
                title: const Text("Terminar sessão"),
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                onTap: () async {
                  await showConfDialog(
                    context,
                    "Tem a certeza que quer terminar sessão?",
                  ).then((value) {
                    setState(() {
                      //? This "Sets the state" although it doesn't update anything
                      //* If the user confirms to log out
                      if (value) {
                        // Sets the user as not logged in
                        isLogged = false;

                        // 'Deletes' the user, only in the files
                        user!.delete().then((value) {
                          //? This triggers the setState method so that the ui updates
                          user!.getInstance().then((value) {
                            setState(() {
                              user = value;
                            });
                          });
                        });
                      }
                    });
                  }).then(
                    (value) => setState,
                  ); //? This triggers the setState method so that the ui updates
                },
              ),
            ],
          )
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
            //TODO: Add user settings widgets, dark mode, notifications, reminders, etc. (Only if the user is logged in)
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
                Text(
                  version,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                const Text(
                  "Configurações",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //? Dark mode switch
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Modo Escuro",
                      style: TextStyle(
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
