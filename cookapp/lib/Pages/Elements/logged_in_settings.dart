import 'package:cookapp/Classes/app_state.dart';
import 'package:cookapp/Classes/user.dart';
import 'package:cookapp/Pages/Elements/drawer_header.dart';
import 'package:flutter/material.dart';
import 'package:cookapp/Functions/show_conf_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget loggedInSettings(BuildContext context, User user) {
  final loc = AppLocalizations.of(context)!;
  return Column(
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
        title: Text(loc.privacy),
        leading: const Icon(Icons.remove_red_eye),
        onTap: null,
      ),
      //* Account Details
      ListTile(
        title: Text(loc.account_details),
        leading: const Icon(Icons.account_circle),
        onTap: null,
      ),
      //* About
      ListTile(
        title: Text(loc.about),
        leading: const Icon(Icons.info),
        onTap: null,
      ),
      //* Divider
      const Divider(),
      //* Go back button
      ListTile(
        title: Text(loc.goBack),
        leading: const Icon(Icons.arrow_back),
        onTap: () {
          // Close the drawer if open, then the page if possible
          Navigator.of(context).maybePop();
          Navigator.of(context).maybePop();
        },
      ),
      ListTile(
        title: Text(loc.logout),
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
}
