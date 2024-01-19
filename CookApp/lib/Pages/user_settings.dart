// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';

import 'login_page.dart';
import 'register_page.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  bool isLogged = false;

  @override
  Widget build(BuildContext context) {
    const drawerHeader = UserAccountsDrawerHeader(
      accountName: Text("User Name"),
      accountEmail: Text("User Email"),
      currentAccountPicture: CircleAvatar(
        child: FlutterLogo(size: 42.0),
      ),
    );

    const anonymousDrawerHeader = UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
      ),
      accountName: Text("Utilizador Anónimo"),
      accountEmail: Text("Faça logon para aceder aos serviços",
          style: TextStyle(color: Colors.orange)),
      currentAccountPicture: CircleAvatar(
        child: Icon(Icons.person, size: 42.0),
      ),
    );

    final drawerItems = isLogged
        ? ListView(
            children: [
              drawerHeader,
              ListTile(
                title: const Text("Item 1"),
                leading: const Icon(Icons.favorite),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Item 2"),
                leading: const Icon(Icons.comment),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          )
        : ListView(
            children: [
              anonymousDrawerHeader,
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
                  );
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
            ],
          );
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Settings"),
      ),
      body: Semantics(
        container: true,
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(50.0),
            child: const Text("User Settings"),
          ),
        ),
      ),
      drawer: Drawer(
        child: drawerItems,
      ),
    );
  }
}
