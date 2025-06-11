import 'package:cookapp/Classes/app_state.dart';
import 'package:cookapp/Classes/user.dart';
import 'package:cookapp/Pages/Elements/drawer_header.dart';
import 'package:flutter/material.dart';
import 'package:cookapp/Functions/show_conf_dialog.dart';

Widget loggedInSettings(BuildContext context, User user) => Column(
      children: [
        drawerHeader(user),
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
          onTap: null,
        ),

        //* Divider
        const Divider(),
        //* Account Details
        ListTile(
          title: const Text("Detalhes da Conta"),
          leading: const Icon(Icons.account_circle),
          onTap: null,
        ),
        //* Settings
        ListTile(
          title: const Text("Definições"),
          leading: const Icon(Icons.settings),
          onTap: null,
        ),
        //* Divider
        const Divider(),
        //* About
        ListTile(
          title: const Text("Sobre"),
          leading: const Icon(Icons.info),
          onTap: null,
        ),
        //* Divider
        const Divider(),
        //* Go back button
        ListTile(
          title: const Text("Voltar"),
          leading: const Icon(Icons.arrow_back),
          onTap: () {
            // Close the drawer if open, then the page if possible
            Navigator.of(context).maybePop();
            Navigator.of(context).maybePop();
          },
        ),
        ListTile(
          title: const Text("Terminar sessão"),
          leading: const Icon(
            Icons.logout,
            color: Colors.red,
          ),
          onTap: () async {
            final navigator = Navigator.of(context);
            await showConfDialog(
              context,
              "Tem a certeza que quer terminar sessão?",
            ).then((value) {
              if (value) {
                AppState().logout();

                if (navigator.canPop()) {
                  navigator.pop(); // Close the drawer
                }
              }
            });
          },
        ),
      ],
    );
