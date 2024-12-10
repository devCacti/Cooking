// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import '../Functions/data_structures.dart';
import 'login_page.dart';
import 'register_page.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  User user = User.getInstance();

  bool isLogged = false;

  //TODO: Add user checking logic, if the user is logged in, show the user information, else, show like if isLogged is false
  @override
  Widget build(BuildContext context) {
    final drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(user.username),
      accountEmail: Text(user.email),
      currentAccountPicture: const CircleAvatar(
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

    setState(() {
      isLogged = user.guid != "";
    });

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
              //* Divider
              const Divider(),
              //* Change isLogged state
              ListTile(
                title: isLogged
                    ? const Text("Simular Anónimo")
                    : const Text("Simular Logado"),
                leading: const Icon(Icons.person),
                onTap: () {
                  setState(() {
                    isLogged = !isLogged;
                  });
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
              //* Divider
              const Divider(),
              //* Change isLogged state
              ListTile(
                title: isLogged
                    ? const Text("Simular Anónimo")
                    : const Text("Simular Logado"),
                leading: const Icon(Icons.person),
                onTap: () {
                  setState(() {
                    isLogged = !isLogged;
                  });
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
        title: const Text("User Settings"),
      ),
      body: Semantics(
        container: true,
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(50.0),
            //TODO: Add user settings widgets, dark mode, notifications, reminders, etc. (Only if the user is logged in)
            child: const Text("Definições do Utilizador"),
          ),
        ),
      ),
      drawer: Drawer(
        child: drawerItems,
      ),
    );
  }
}
